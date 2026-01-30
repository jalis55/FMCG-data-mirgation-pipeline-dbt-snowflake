{% macro handle_date_format(date_column) %}
    coalesce(
        -- Your most common format FIRST (for performance)
        try_to_date(trim({{ date_column }}), 'DD-MM-YYYY'),
        
        -- ISO and standard numeric formats
        try_to_date(trim({{ date_column }}), 'YYYY-MM-DD'),
        try_to_date(trim({{ date_column }}), 'YYYY/MM/DD'),
        try_to_date(trim({{ date_column }}), 'YYYYMMDD'),
        
        -- US formats
        try_to_date(trim({{ date_column }}), 'MM/DD/YYYY'),
        try_to_date(trim({{ date_column }}), 'MM-DD-YYYY'),
        try_to_date(trim({{ date_column }}), 'MM.DD.YYYY'),
        
        -- European formats
        try_to_date(trim({{ date_column }}), 'DD/MM/YYYY'),
        try_to_date(trim({{ date_column }}), 'DD.MM.YYYY'),
        
        -- 2-digit year formats
        try_to_date(trim({{ date_column }}), 'DD-MM-YY'),
        try_to_date(trim({{ date_column }}), 'MM/DD/YY'),
        try_to_date(trim({{ date_column }}), 'DD/MM/YY'),
        try_to_date(trim({{ date_column }}), 'YY-MM-DD'),
        try_to_date(trim({{ date_column }}), 'YYMMDD'),
        
        -- Full month name with day-of-week (strip day name first)
        try_to_date(
            regexp_replace(trim({{ date_column }}), '^\\w+,\\s*', ''),
            'MMMM DD, YYYY'
        ),
        try_to_date(
            regexp_replace(trim({{ date_column }}), '^\\w+,\\s*', ''),
            'DD MMMM YYYY'
        ),
        try_to_date(
            regexp_replace(trim({{ date_column }}), '^\\w+,\\s*', ''),
            'MMMM DD YYYY'
        ),
        
        -- Full month name without day-of-week
        try_to_date(trim({{ date_column }}), 'MMMM DD, YYYY'),
        try_to_date(trim({{ date_column }}), 'DD MMMM YYYY'),
        try_to_date(trim({{ date_column }}), 'MMMM DD YYYY'),
        try_to_date(trim({{ date_column }}), 'DD-MMMM-YYYY'),
        
        -- Abbreviated month (Jan, Feb, etc.) with day-of-week
        try_to_date(
            regexp_replace(trim({{ date_column }}), '^\\w+,\\s*', ''),
            'MON DD, YYYY'
        ),
        try_to_date(
            regexp_replace(trim({{ date_column }}), '^\\w+,\\s*', ''),
            'DD MON YYYY'
        ),
        try_to_date(
            regexp_replace(trim({{ date_column }}), '^\\w+,\\s*', ''),
            'MON DD YYYY'
        ),
        
        -- Abbreviated month without day-of-week
        try_to_date(trim({{ date_column }}), 'MON DD, YYYY'),
        try_to_date(trim({{ date_column }}), 'DD MON YYYY'),
        try_to_date(trim({{ date_column }}), 'DD-MON-YYYY'),
        try_to_date(trim({{ date_column }}), 'MON DD YYYY'),
        
        -- Abbreviated month with 2-digit year
        try_to_date(trim({{ date_column }}), 'DD-MON-YY'),
        try_to_date(trim({{ date_column }}), 'MON DD, YY'),
        
        -- Alternative separators
        try_to_date(trim({{ date_column }}), 'YYYY.MM.DD'),
        try_to_date(trim({{ date_column }}), 'DD.MM.YY'),
        
        -- Timestamp formats (will extract just the date)
        try_to_date(trim({{ date_column }}), 'YYYY-MM-DD HH24:MI:SS'),
        try_to_date(trim({{ date_column }}), 'DD/MM/YYYY HH24:MI:SS'),
        try_to_date(trim({{ date_column }}), 'MM/DD/YYYY HH24:MI:SS'),
        
        null
    )
{% endmacro %}