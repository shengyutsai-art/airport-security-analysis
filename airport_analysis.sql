WITH airport AS (
    SELECT *
    FROM read_xlsx('file_input_uploads/airport.xlsx')
), airport_calc AS (
    SELECT
        "date",
        terminal,
        time_interval,
        COALESCE(CAST(departure AS INTEGER), 0) AS 出發人數,
        COALESCE(CAST(transfer_dep AS INTEGER), 0) AS 轉機人數,
        COALESCE(CAST(departure AS INTEGER), 0) + COALESCE(CAST(transfer_dep AS INTEGER), 0) AS 預估安檢總人數
    FROM airport
    WHERE terminal = 'T1'
)
SELECT
    "date",
    terminal,
    time_interval,
    出發人數,
    轉機人數,
    預估安檢總人數,
    CASE
        WHEN 預估安檢總人數 >= 1500 THEN '🔴 極度擁擠 (需增派支援)'
        WHEN 預估安檢總人數 BETWEEN 1000 AND 1499 THEN '🟡 正常滿載'
        ELSE '🟢 離峰 (可輪休)'
    END AS 擁擠狀態
FROM airport_calc
ORDER BY "date", 預估安檢總人數 DESC;
