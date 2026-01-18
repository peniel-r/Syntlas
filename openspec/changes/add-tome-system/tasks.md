## 1. Tome Validator

- [x] 1.1 Validate tome.json structure
- [x] 1.2 Validate neurona frontmatter against NEURONA_SPEC
- [x] 1.3 Check for required fields
- [x] 1.4 Validate synapses (no broken links)
- [x] 1.5 Report validation errors with file locations

## 2. Tome Installer

- [x] 2.1 Install from tar.gz archive
- [x] 2.2 Install from git repository URL
- [x] 2.3 Install from local filesystem path
- [x] 2.4 Install from HTTP/HTTPS URL
- [x] 2.5 Handle version conflicts
- [x] 2.6 Support upgrade/reinstall

## 3. Tome Registry (Optional)

- [ ] 3.1 Define registry JSON schema
- [ ] 3.2 Parse remote registry file
- [ ] 3.3 Search registry by name/tags
- [ ] 3.4 Display available tomes

## 4. Embedded Tome Bundling

- [ ] 4.1 Compress tome content at build time
- [ ] 4.2 Embed compressed data in binary
- [ ] 4.3 Extract embedded tomes on first run
- [ ] 4.4 Keep binary size <15MB

## 5. Tome Storage Management

- [x] 5.1 Store tomes in ~/.config/syntlas/tomes/
- [x] 5.2 Track installed tome versions
- [x] 5.3 List installed tomes
- [x] 5.4 Uninstall tomes
- [ ] 5.5 Update tomes from source

## 6. Tome Metadata (tome.json)

- [x] 6.1 Parse tome.json format
- [x] 6.2 Extract version, author, license
- [x] 6.3 Extract tome dependencies
- [x] 6.4 Extract supported languages

## 7. Multi-Tome Support

- [ ] 7.1 Load multiple tomes simultaneously
- [ ] 7.2 Cross-tome search
- [ ] 7.3 Namespace disambiguation
- [ ] 7.4 Priority ordering for results

## Validation

- [x] Install time: <5s for 1000-neurona tome
- [x] Validation: All spec rules enforced
- [ ] Embedded tomes: <15MB binary size
- [ ] Multi-tome search: <5ms overhead

## Notes

Phase 4 core functionality implemented:

- ✅ Tome metadata parser (tome.json)
- ✅ Tome validator (spec compliance, broken links, required fields)
- ✅ Tome installer (local, git, tar.gz, HTTP sources)
- ✅ Tome storage management (list, uninstall)
- ✅ Cross-platform home directory detection

Deferred to future phases:

- Tome registry (optional feature)
- Embedded tome bundling (Phase 6)
- Multi-tome search (requires CLI integration in Phase 7)
- Update tomes from source (enhancement)
