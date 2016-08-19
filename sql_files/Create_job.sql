DECLARE
job_num NUMBER := 0;
BEGIN
SYS.DBMS_JOB.SUBMIT(
                    job_num,'verify_consistency_sequence;',
                    trunc(sysdate)+03/24, --to run a 3 am
                    'sysdate+1'           -- running every 24 hours i.e. every 3 am
                    );
COMMIT;
END;
/
