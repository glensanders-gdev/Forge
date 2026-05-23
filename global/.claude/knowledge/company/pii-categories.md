# Custom PII Categories

Extends the default PII categories used by `/pii-check`. Add company or project-specific PII types here.

**Last updated:** YYYY-MM-DD

---

## Default Categories (Reference Only)

The following are always scanned without needing to be listed here:
- Names, email addresses, phone numbers, physical addresses
- Government IDs (passport, national ID, tax file number, SSN)
- Financial data (card numbers, account numbers, BSB, IBAN)
- Health data (medical record numbers, diagnoses, health identifiers)
- Dates of birth

---

## Custom Categories

<!--
Add project or company-specific PII categories below.

Format:

## [Category Name]
**Description:** What this category covers
**Examples:** [pattern or format — never use real data as examples]
**Handling requirements:** [company-specific requirements for this data type]
**Regex hint (optional):** [pattern to help detection]

Example:

## Member Numbers
**Description:** Internal membership identifiers that map to real people
**Examples:** LB-XXXXXX format (6 digits)
**Handling requirements:** Must not appear in logs or error messages. Access restricted to committee role.
**Regex hint:** LB-\d{6}
-->
