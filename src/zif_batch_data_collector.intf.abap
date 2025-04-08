INTERFACE zif_batch_data_collector
  PUBLIC .
*  TYPES: BEGIN OF zbatch_data,
*         collector_id     TYPE char30,        " Unique ID for the collector
*         job_name         TYPE btcjob,        " Name of the batch job
*         execution_time   TYPE timestampl,    " UTC timestamp of job execution
*         status           TYPE char10,        " SUCCESS / ERROR / WARNING etc.
*         key_field        TYPE char50,        " Optional identifier (e.g. PO#, Invoice#, etc.)
*         message          TYPE string,        " Optional message or status text
*         json_payload     TYPE string,        " Raw JSON (optional - for Fiori/API)
*       END OF zbatch_data.

*      TYPES zbatch_data_TT standa
  TYPES: zbatch_data_tt TYPE STANDARD TABLE OF zbatch_data.
  METHODS:
    collect_data
      IMPORTING iv_jobname TYPE char32
      EXPORTING rt_data    TYPE zbatch_data_tt.

ENDINTERFACE.
