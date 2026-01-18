---
id: "python.stdlib.logging"
title: "Logging"
category: stdlib
difficulty: intermediate
tags: [python, logging, debug, monitoring]
keywords: [logging, logger, handler, formatter]
use_cases: [debugging, application monitoring, audit trails]
prerequisites: ["python.classes"]
related: ["python.exceptions"]
next_topics: []
---

# Logging

Python's `logging` module provides flexible event logging.

## Basic Logging

```python
import logging

# Configure basic logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)

logging.debug("This won't appear (below INFO)")
logging.info("Application started")
logging.warning("This is a warning")
logging.error("An error occurred")
logging.critical("Critical failure!")
```

## Getting a Logger

```python
import logging

# Get logger for current module
logger = logging.getLogger(__name__)

logger.info("Module initialized")
logger.error("Something failed")
```

## Log Levels

```python
import logging

# Levels (from lowest to highest)
# DEBUG - Detailed diagnostic info
logger.debug("Variable x = %s", x)

# INFO - Confirmation things work as expected
logger.info("Connected to database")

# WARNING - Unexpected but recoverable
logger.warning("Cache miss, fetching from database")

# ERROR - Serious problem, software still running
logger.error("Failed to write to disk")

# CRITICAL - Very serious error, program may crash
logger.critical("Database connection lost")
```

## Handlers - Output Destinations

```python
import logging

# Create handlers
file_handler = logging.FileHandler('app.log')
console_handler = logging.StreamHandler()

# Set levels
file_handler.setLevel(logging.DEBUG)
console_handler.setLevel(logging.INFO)

# Set format
formatter = logging.Formatter(
    '%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
file_handler.setFormatter(formatter)
console_handler.setFormatter(formatter)

# Add handlers to logger
logger = logging.getLogger('my_app')
logger.addHandler(file_handler)
logger.addHandler(console_handler)
logger.info("Message goes to both file and console")
```

## Rotating File Handlers

```python
import logging
from logging.handlers import RotatingFileHandler, TimedRotatingFileHandler

# Rotate when file reaches size limit
handler = RotatingFileHandler(
    'app.log',
    maxBytes=10*1024*1024,  # 10 MB
    backupCount=5
)

# Rotate by time
handler = TimedRotatingFileHandler(
    'app.log',
    when='midnight',
    interval=1,
    backupCount=7
)
```

## Custom Formatting

```python
import logging

# JSON logging for parsing
class JsonFormatter(logging.Formatter):
    def format(self, record):
        return json.dumps({
            "timestamp": self.formatTime(record),
            "level": record.levelname,
            "name": record.name,
            "message": record.getMessage()
        })

handler = logging.StreamHandler()
handler.setFormatter(JsonFormatter())
```

## Filtering Logs

```python
import logging

# Filter by level
logger.setLevel(logging.WARNING)
logger.debug("Won't appear")  # Below WARNING
logger.warning("Will appear")

# Custom filter
class DebugOnlyFilter(logging.Filter):
    def filter(self, record):
        return record.levelno == logging.DEBUG

handler = logging.StreamHandler()
handler.addFilter(DebugOnlyFilter())
```

## Structured Logging

```python
import logging

# Use logging.config for complex setup
import logging.config

LOGGING_CONFIG = {
    'version': 1,
    'disable_existing_loggers': False,
    'formatters': {
        'standard': {
            'format': '%(asctime)s [%(levelname)s] %(name)s: %(message)s'
        }
    },
    'handlers': {
        'console': {
            'class': 'logging.StreamHandler',
            'formatter': 'standard'
        }
    },
    'loggers': {
        '': {
            'handlers': ['console'],
            'level': 'INFO'
        }
    }
}

logging.config.dictConfig(LOGGING_CONFIG)
```

## Common Patterns

### Function entry/exit logging
```python
import logging
from functools import wraps

logger = logging.getLogger(__name__)

def log_function_calls(func):
    @wraps(func)
    def wrapper(*args, **kwargs):
        logger.debug(f"Entering {func.__name__}")
        try:
            result = func(*args, **kwargs)
            logger.debug(f"Exiting {func.__name__} with result: {result}")
            return result
        except Exception as e:
            logger.error(f"Error in {func.__name__}: {e}")
            raise
    return wrapper

@log_function_calls
def process_data(data):
    # Function is automatically logged
    pass
```

### Request/Response logging
```python
import logging

logger = logging.getLogger(__name__)

def handle_request(request):
    logger.info(f"Request: {request.method} {request.path}")

    try:
        response = process(request)
        logger.info(f"Response: {response.status_code}")
        return response
    except Exception as e:
        logger.error(f"Request failed: {e}", exc_info=True)
        raise
```

### Performance logging
```python
import logging
import time

logger = logging.getLogger(__name__)

def log_performance(func):
    @wraps(func)
    def wrapper(*args, **kwargs):
        start = time.time()
        try:
            result = func(*args, **kwargs)
            elapsed = time.time() - start
            logger.info(f"{func.__name__} took {elapsed:.4f}s")
            return result
        except Exception as e:
            elapsed = time.time() - start
            logger.error(f"{func.__name__} failed after {elapsed:.4f}s: {e}")
            raise
    return wrapper

@log_performance
def slow_operation():
    time.sleep(1)
    return "done"
```

### Exception traceback logging
```python
import logging

logger = logging.getLogger(__name__)

try:
    risky_operation()
except Exception:
    # Include full traceback
    logger.exception("Operation failed")
    # Equivalent to:
    # logger.error("Operation failed", exc_info=True)
```

> **Best Practice**: Don't use `print()` for logging in production - use the logging module for flexibility.
