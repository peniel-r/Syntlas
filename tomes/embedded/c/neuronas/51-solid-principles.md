---
id: "c.patterns.solid"
title: "SOLID Principles"
category: patterns
difficulty: advanced
tags: [c, patterns, solid, design, architecture]
keywords: [solid, single responsibility, open-closed, liskov]
use_cases: [software design, architecture, maintainability]
prerequisites: ["c.patterns.structs"]
related: ["c.patterns.callbacks"]
next_topics: ["c.patterns.mvc"]
---

# SOLID Principles

## Single Responsibility

```c
#include <stdio.h>
#include <stdlib.h>

// Bad: Multiple responsibilities
typedef struct {
    char name[50];
    int age;
    void (*print)(void);  // Shouldn't be here
} PersonBad;

// Good: Single responsibility
typedef struct {
    char name[50];
    int age;
} PersonGood;

void print_person(const PersonGood* p) {
    printf("Name: %s, Age: %d\n", p->name, p->age);
}

int main() {
    PersonGood p = {"Alice", 30};
    print_person(&p);

    return 0;
}
```

## Open-Closed Principle

```c
#include <stdio.h>
#include <stdlib.h>

typedef struct {
    const char* name;
    void (*process)(const void*);
} Processor;

void process_csv(const void* data) {
    printf("Processing CSV\n");
}

void process_json(const void* data) {
    printf("Processing JSON\n");
}

void process_xml(const void* data) {
    printf("Processing XML\n");
}

// Open for extension, closed for modification
Processor* processors[] = {
    {"CSV", process_csv},
    {"JSON", process_json},
    {"XML", process_xml}
};

void process_data(const char* format, const void* data) {
    int count = sizeof(processors) / sizeof(processors[0]);

    for (int i = 0; i < count; i++) {
        if (strcmp(processors[i].name, format) == 0) {
            processors[i].process(data);
            return;
        }
    }

    printf("Unknown format: %s\n", format);
}

int main() {
    const char* data = "sample data";
    process_data("CSV", data);
    process_data("JSON", data);

    return 0;
}
```

## Liskov Substitution

```c
#include <stdio.h>

typedef struct {
    void (*draw)(const void*);
} Shape;

typedef struct {
    const char* type;
    int width;
    int height;
} Rectangle;

void draw_rectangle(const void* shape) {
    const Rectangle* r = (const Rectangle*)shape;
    printf("Rectangle: %dx%d\n", r->width, r->height);
}

Shape create_rectangle(int width, int height) {
    Rectangle* r = malloc(sizeof(Rectangle));
    r->type = "rectangle";
    r->width = width;
    r->height = height;

    Shape s = {draw_rectangle};
    return s;
}

typedef struct {
    const char* type;
    int side;
} Square;

void draw_square(const void* shape) {
    const Square* s = (const Square*)shape;
    printf("Square: %dx%d\n", s->side, s->side);
}

Shape create_square(int side) {
    Square* s = malloc(sizeof(Square));
    s->type = "square";
    s->side = side;

    Shape shape = {draw_square};
    return shape;
}

// Both Rectangle and Square can be used as Shape
void draw_shape(const Shape* shape) {
    shape->draw(NULL);  // In real code, pass actual shape data
}

int main() {
    Shape rect = create_rectangle(10, 20);
    Shape sq = create_square(15);

    draw_shape(&rect);
    draw_shape(&sq);

    return 0;
}
```

## Interface Segregation

```c
#include <stdio.h>

// Bad: Fat interface
typedef struct {
    void (*print)(const void*);
    void (*fax)(const void*);    // Not all printers support fax
    void (*scan)(const void*);   // Not all printers support scan
} PrinterBad;

// Good: Segregated interfaces
typedef struct {
    void (*print)(const void*);
} IPrintable;

typedef struct {
    void (*scan)(const void*);
} IScannable;

typedef struct {
    const char* name;
} BasicPrinter;

void basic_print(const void* printer) {
    const BasicPrinter* p = (const BasicPrinter*)printer;
    printf("Printing on: %s\n", p->name);
}

typedef struct {
    const char* name;
} MultifunctionPrinter;

void multi_print(const void* printer) {
    const MultifunctionPrinter* p = (const MultifunctionPrinter*)printer;
    printf("Printing on: %s\n", p->name);
}

void multi_scan(const void* printer) {
    const MultifunctionPrinter* p = (const MultifunctionPrinter*)printer;
    printf("Scanning on: %s\n", p->name);
}

int main() {
    IPrintable basic = {basic_print};
    IPrintable multi = {multi_print};
    IScannable scan = {multi_scan};

    BasicPrinter bp = {"BasicPrinter"};
    basic.print(&bp);

    MultifunctionPrinter mp = {"MultifunctionPrinter"};
    multi.print(&mp);
    scan.scan(&mp);

    return 0;
}
```

## Dependency Inversion

```c
#include <stdio.h>
#include <stdlib.h>

// Bad: High-level depends on low-level
typedef struct {
    void (*save)(const char*);
} DatabaseBad;

void save_mysql(const char* data) {
    printf("Saving to MySQL: %s\n", data);
}

void save_postgres(const char* data) {
    printf("Saving to PostgreSQL: %s\n", data);
}

// Good: High-level depends on abstraction
typedef struct {
    void (*save)(const char*);
} IDatabase;

void save_to_database(IDatabase* db, const char* data) {
    db->save(data);
}

int main() {
    // Inject dependency
    IDatabase mysql = {save_mysql};
    IDatabase postgres = {save_postgres};

    save_to_database(&mysql, "sample data");
    save_to_database(&postgres, "sample data");

    return 0;
}
```

## Strategy Pattern

```c
#include <stdio.h>
#include <stdlib.h>

typedef struct {
    void (*execute)(void*);
} Strategy;

void bubble_sort(void* data) {
    printf("Using bubble sort\n");
}

void quick_sort(void* data) {
    printf("Using quick sort\n");
}

void merge_sort(void* data) {
    printf("Using merge sort\n");
}

Strategy* get_strategy(int size) {
    if (size < 10) {
        static Strategy s = {bubble_sort};
        return &s;
    } else if (size < 100) {
        static Strategy s = {quick_sort};
        return &s;
    } else {
        static Strategy s = {merge_sort};
        return &s;
    }
}

int main() {
    int data[] = {5, 3, 8, 1, 9};

    Strategy* strategy = get_strategy(sizeof(data) / sizeof(data[0]));
    strategy->execute(data);

    return 0;
}
```

## Factory Pattern

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
    const char* name;
    void (*operation)(void);
} Product;

typedef struct {
    Product* (*create)(void);
} Factory;

void concrete_product_a(void) {
    printf("Product A operation\n");
}

void concrete_product_b(void) {
    printf("Product B operation\n");
}

Product* create_product_a(void) {
    Product* p = malloc(sizeof(Product));
    p->name = "ProductA";
    p->operation = concrete_product_a;
    return p;
}

Product* create_product_b(void) {
    Product* p = malloc(sizeof(Product));
    p->name = "ProductB";
    p->operation = concrete_product_b;
    return p;
}

Factory* get_factory(const char* type) {
    if (strcmp(type, "A") == 0) {
        static Factory f = {create_product_a};
        return &f;
    } else {
        static Factory f = {create_product_b};
        return &f;
    }
}

int main() {
    Factory* factory_a = get_factory("A");
    Factory* factory_b = get_factory("B");

    Product* pa = factory_a->create();
    Product* pb = factory_b->create();

    printf("Created: %s\n", pa->name);
    pa->operation();

    printf("Created: %s\n", pb->name);
    pb->operation();

    free(pa);
    free(pb);

    return 0;
}
```

## Observer Pattern

```c
#include <stdio.h>
#include <stdlib.h>

typedef struct {
    void (*update)(int);
} Observer;

typedef struct {
    Observer** observers;
    int count;
    int capacity;
} Subject;

Subject* create_subject(int capacity) {
    Subject* s = malloc(sizeof(Subject));
    s->observers = malloc(capacity * sizeof(Observer*));
    s->count = 0;
    s->capacity = capacity;
    return s;
}

void attach_observer(Subject* s, Observer* o) {
    if (s->count < s->capacity) {
        s->observers[s->count++] = o;
    }
}

void notify_observers(Subject* s, int value) {
    for (int i = 0; i < s->count; i++) {
        s->observers[i]->update(value);
    }
}

void observer_update1(int value) {
    printf("Observer1: Value = %d\n", value);
}

void observer_update2(int value) {
    printf("Observer2: Value = %d\n", value);
}

int main() {
    Subject* subject = create_subject(2);

    Observer o1 = {observer_update1};
    Observer o2 = {observer_update2};

    attach_observer(subject, &o1);
    attach_observer(subject, &o2);

    notify_observers(subject, 42);

    free(subject->observers);
    free(subject);

    return 0;
}
```

## Builder Pattern

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
    char* name;
    int age;
    char* address;
} Person;

typedef struct {
    Person person;
    void (*set_name)(void*, const char*);
    void (*set_age)(void*, int);
    void (*set_address)(void*, const char*);
    Person* (*build)(void*);
} PersonBuilder;

void builder_set_name(void* self, const char* name) {
    PersonBuilder* builder = (PersonBuilder*)self;
    free(builder->person.name);
    builder->person.name = strdup(name);
}

void builder_set_age(void* self, int age) {
    PersonBuilder* builder = (PersonBuilder*)self;
    builder->person.age = age;
}

void builder_set_address(void* self, const char* address) {
    PersonBuilder* builder = (PersonBuilder*)self;
    free(builder->person.address);
    builder->person.address = strdup(address);
}

Person* builder_build(void* self) {
    PersonBuilder* builder = (PersonBuilder*)self;
    Person* result = malloc(sizeof(Person));
    *result = builder->person;
    return result;
}

PersonBuilder* create_builder(void) {
    PersonBuilder* builder = malloc(sizeof(PersonBuilder));
    builder->person.name = NULL;
    builder->person.age = 0;
    builder->person.address = NULL;
    builder->set_name = builder_set_name;
    builder->set_age = builder_set_age;
    builder->set_address = builder_set_address;
    builder->build = builder_build;
    return builder;
}

void free_builder(PersonBuilder* builder) {
    free(builder->person.name);
    free(builder->person.address);
    free(builder);
}

int main() {
    PersonBuilder* builder = create_builder();

    builder->set_name(builder, "Alice");
    builder->set_age(builder, 30);
    builder->set_address(builder, "123 Main St");

    Person* person = builder->build(builder);

    printf("Person: %s, %d, %s\n",
           person->name, person->age, person->address);

    free(person);
    free_builder(builder);

    return 0;
}
```

## Template Method Pattern

```c
#include <stdio.h>

typedef struct {
    void (*step1)(void*);
    void (*step2)(void*);
    void (*step3)(void*);
} Template;

void template_execute(Template* t, void* context) {
    printf("Step 1: ");
    t->step1(context);

    printf("Step 2: ");
    t->step2(context);

    printf("Step 3: ");
    t->step3(context);
}

void custom_step1(void* ctx) {
    printf("Custom step 1\n");
}

void custom_step2(void* ctx) {
    printf("Custom step 2\n");
}

void custom_step3(void* ctx) {
    printf("Custom step 3\n");
}

int main() {
    Template t = {custom_step1, custom_step2, custom_step3};
    template_execute(&t, NULL);

    return 0;
}
```

> **Note**: SOLID principles improve maintainability but may add complexity. Apply judiciously based on project needs.
