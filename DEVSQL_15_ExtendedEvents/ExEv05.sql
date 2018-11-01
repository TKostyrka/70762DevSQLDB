SELECT
    f.object_name,
    f.file_name,
    f.file_offset,
    f.event_data,
    CAST(f.event_data AS XML) AS [event_data_XML]
FROM
    sys.fn_xe_file_target_read_file(
        'C:\ExEv\MyNewSessionDump_0_131855668295270000.xel',
        null, null, null
    ) AS f;