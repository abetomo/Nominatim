CREATE EXTENSION IF NOT EXISTS pgroonga;

ALTER TABLE search_name ADD COLUMN IF NOT EXISTS all_names text;

-- Update all_names from placex name fields
UPDATE search_name SET all_names = (
    SELECT concat_ws(' ',
        name->'name',
        name->'name:en',
        name->'alt_name',
        name->'short_name',
        name->'name:ja-Hira',
        name->'name:ja',
        name->'name:ko',
        name->'name:zh'
    )
    FROM placex WHERE placex.place_id = search_name.place_id
);

CREATE INDEX IF NOT EXISTS idx_search_name_pgroonga
    ON search_name USING pgroonga (all_names);
