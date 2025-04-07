# LegoUseCase

## 📌 End-to-End Process Overview

1. **Fetch Collectors**  
   The custom framework reads a list of registered collector handlers from the table `ZCOLLECTOR_REG`.

2. **Invoke Collector Handlers**  
   Each collector represents a specific ECC batch job. The framework invokes the respective ABAP class to handle the job.

3. **Spool Data to JSON**  
   Each collector reads the spool output of its respective batch job, parses the data, and converts it to JSON format.

4. **Save to ZBATCH_DATA**  
   The framework saves the JSON payload and metadata (e.g., job name, execution time, record count, status) into the generic table `ZBATCH_DATA`.

5. **Send to AWS Cloud API**  
   The framework then invokes a separate method to push this JSON payload to a designated AWS Cloud API endpoint.

6. **Expose via Fiori**  
   A CDS View on top of `ZBATCH_DATA` is used to expose this data, which is visualized in a unified Fiori UI.

---

## 🏗️ Architecture Diagram

![Batch Monitoring Architecture](./batch-monitoring-architecture.png)

---

## ⚠️ Error Handling and Failure Points

| Stage                         | Potential Failure                             | Handling Strategy                                                   |
|------------------------------|-----------------------------------------------|---------------------------------------------------------------------|
| Fetching collectors          | Table empty, invalid/inactive collectors      | Skip invalid entries, log missing handlers                         |
| Calling handlers             | Missing class, unhandled exception            | Wrap in TRY-CATCH, update `status` and `message` in `ZBATCH_DATA`  |
| Spool reading & parsing      | Spool not found, empty/corrupt data           | Validate spool, handle edge cases, log errors                      |
| JSON conversion              | Malformed structure, large payload            | Catch conversion errors, truncate or split large JSON              |
| Saving to ZBATCH_DATA        | DB insert failure, key collision              | Use `INSERT OR UPDATE`, log SQL exceptions                         |
| Cloud API call               | Network issues, auth failure, 4xx/5xx response| Handle HTTP response, retry with backoff, update `status` field    |
| Fiori JSON visualization     | JSON structure varies, parse error on UI      | Validate JSON before saving, implement fallback UI behavior        |

---

## 🔧 Additional Recommendations

- Central logging using a utility class (e.g., `ZLOGGER`)
- Background job retry mechanism for failed collectors
- Notification via email or monitoring tools in case of repeated failures
- Unit testing for collector classes and JSON payloads

