# LegoUseCase

## 🏗️ Architecture Diagram

![Batch Monitoring Architecture](./docs/batch-monitoring-architecture.png)

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
