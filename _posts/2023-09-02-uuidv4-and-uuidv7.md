---
layout: post
title: "Comparing UUIDv4 v.s. UUIDv7 in PostgreSQL"
tags:
  - "PostgreSQL"
  - "UUID"
---

UUIDv4 is widly used, but it's not suitable for database primary key. Because it's not sequential, and it's not sortable. [UUIDv7](https://www.ietf.org/archive/id/draft-peabody-dispatch-new-uuid-format-04.html) is a new UUID version, it's sequential and sortable. It looks interesting to use it for database primary keys.

I did some comparison between UUIDv4 and UUIDv7 in PostgreSQL.

A simple script to generate UUIDv7:

```js
import { uuidv7 } from "@kripod/uuidv7";

console.log("copy v7 from stdin;")
for (let i = 0; i < 1000000; i++) {
    console.log(uuidv7());
}
console.log("\\.")
```

The SQL:

```sql
create table v4 (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4()
);

create table v7 (
    id UUID PRIMARY KEY
);

insert into v4 select uuid_generate_v4() from generate_series(1, 1000000);

xui=> select * from v4 limit 1;
                  id
--------------------------------------
 e499ad84-9756-4075-8d65-8b5874a56794
(1 row)
```

Import v7 UUIDs:

```sh
node v7.js > v7.sql
cat v7.sql | psql -h localhost -U xui xui
```

Compare with 1 million rows:

```sql
xui=> select count(1) from v4;
  count
---------
 1000000
(1 row)

xui=> select count(1) from v7;
  count
---------
 1000000
(1 row)

xui=> select * from v4 limit 1;
                  id
--------------------------------------
 e499ad84-9756-4075-8d65-8b5874a56794
(1 row)

xui=> select * from v7 limit 1;
                  id
--------------------------------------
 018a55ff-b176-7000-bb78-04d69d360285
(1 row)

xui=> explain ANALYZE VERBOSE select * from v4 where id = 'e499ad84-9756-4075-8d65-8b5874a56794';
                                                       QUERY PLAN
-------------------------------------------------------------------------------------------------------------------------
 Index Only Scan using v4_pkey on public.v4  (cost=0.42..8.44 rows=1 width=16) (actual time=2.322..2.325 rows=1 loops=1)
   Output: id
   Index Cond: (v4.id = 'e499ad84-9756-4075-8d65-8b5874a56794'::uuid)
   Heap Fetches: 1
 Planning Time: 0.641 ms
 Execution Time: 2.510 ms
(6 rows)

xui=> explain ANALYZE VERBOSE select * from v7 where id = '018a55ff-b176-7000-bb78-04d69d360285';
                                                       QUERY PLAN
-------------------------------------------------------------------------------------------------------------------------
 Index Only Scan using v7_pkey on public.v7  (cost=0.42..4.44 rows=1 width=16) (actual time=0.503..0.505 rows=1 loops=1)
   Output: id
   Index Cond: (v7.id = '018a55ff-b176-7000-bb78-04d69d360285'::uuid)
   Heap Fetches: 0
 Planning Time: 0.265 ms
 Execution Time: 0.573 ms
(6 rows)

xui=> explain ANALYZE VERBOSE select * from v4 where id = 'e499ad84-9756-4075-8d65-8b5874a56794';
                                                       QUERY PLAN
-------------------------------------------------------------------------------------------------------------------------
 Index Only Scan using v4_pkey on public.v4  (cost=0.42..4.44 rows=1 width=16) (actual time=0.495..0.497 rows=1 loops=1)
   Output: id
   Index Cond: (v4.id = 'e499ad84-9756-4075-8d65-8b5874a56794'::uuid)
   Heap Fetches: 0
 Planning Time: 7.572 ms
 Execution Time: 0.568 ms
(6 rows)

xui=> explain ANALYZE VERBOSE select * from v7 where id = '018a55ff-b176-7000-bb78-04d69d360285';
                                                       QUERY PLAN
-------------------------------------------------------------------------------------------------------------------------
 Index Only Scan using v7_pkey on public.v7  (cost=0.42..4.44 rows=1 width=16) (actual time=0.267..0.268 rows=1 loops=1)
   Output: id
   Index Cond: (v7.id = '018a55ff-b176-7000-bb78-04d69d360285'::uuid)
   Heap Fetches: 0
 Planning Time: 0.480 ms
 Execution Time: 0.324 ms
(6 rows)

xui=> explain ANALYZE VERBOSE select * from v4 where id = 'e499ad84-9756-4075-8d65-8b5874a56794';
                                                       QUERY PLAN
-------------------------------------------------------------------------------------------------------------------------
 Index Only Scan using v4_pkey on public.v4  (cost=0.42..4.44 rows=1 width=16) (actual time=1.214..1.217 rows=1 loops=1)
   Output: id
   Index Cond: (v4.id = 'e499ad84-9756-4075-8d65-8b5874a56794'::uuid)
   Heap Fetches: 0
 Planning Time: 1.482 ms
 Execution Time: 1.422 ms
(6 rows)

xui=> explain ANALYZE VERBOSE select * from v7 where id = '018a55ff-b176-7000-bb78-04d69d360285';
                                                       QUERY PLAN
-------------------------------------------------------------------------------------------------------------------------
 Index Only Scan using v7_pkey on public.v7  (cost=0.42..4.44 rows=1 width=16) (actual time=0.706..0.707 rows=1 loops=1)
   Output: id
   Index Cond: (v7.id = '018a55ff-b176-7000-bb78-04d69d360285'::uuid)
   Heap Fetches: 0
 Planning Time: 0.716 ms
 Execution Time: 0.861 ms
(6 rows)
```

Looks like v7 is always better.

Compare with 3 million rows:

```sql
xui=> select count(1) from v4;
  count
---------
 3000000
(1 row)

xui=> select count(1) from v7;
  count
---------
 3000000
(1 row)

xui=> explain ANALYZE VERBOSE select * from v4 where id = 'e499ad84-9756-4075-8d65-8b5874a56794';
                                                       QUERY PLAN
-------------------------------------------------------------------------------------------------------------------------
 Index Only Scan using v4_pkey on public.v4  (cost=0.43..4.45 rows=1 width=16) (actual time=2.668..2.674 rows=1 loops=1)
   Output: id
   Index Cond: (v4.id = 'e499ad84-9756-4075-8d65-8b5874a56794'::uuid)
   Heap Fetches: 0
 Planning Time: 12.031 ms
 Execution Time: 2.821 ms
(6 rows)

xui=> explain ANALYZE VERBOSE select * from v7 where id = '018a55ff-b176-7000-bb78-04d69d360285';
                                                       QUERY PLAN
-------------------------------------------------------------------------------------------------------------------------
 Index Only Scan using v7_pkey on public.v7  (cost=0.43..8.45 rows=1 width=16) (actual time=2.165..2.169 rows=1 loops=1)
   Output: id
   Index Cond: (v7.id = '018a55ff-b176-7000-bb78-04d69d360285'::uuid)
   Heap Fetches: 0
 Planning Time: 9.861 ms
 Execution Time: 2.352 ms
(6 rows)

xui=> explain ANALYZE VERBOSE select * from v4 where id = 'e499ad84-9756-4075-8d65-8b5874a56794';
                                                       QUERY PLAN
-------------------------------------------------------------------------------------------------------------------------
 Index Only Scan using v4_pkey on public.v4  (cost=0.43..4.45 rows=1 width=16) (actual time=0.662..0.667 rows=1 loops=1)
   Output: id
   Index Cond: (v4.id = 'e499ad84-9756-4075-8d65-8b5874a56794'::uuid)
   Heap Fetches: 0
 Planning Time: 0.873 ms
 Execution Time: 0.813 ms
(6 rows)

xui=> explain ANALYZE VERBOSE select * from v7 where id = '018a55ff-b176-7000-bb78-04d69d360285';
                                                       QUERY PLAN
-------------------------------------------------------------------------------------------------------------------------
 Index Only Scan using v7_pkey on public.v7  (cost=0.43..8.45 rows=1 width=16) (actual time=0.156..0.157 rows=1 loops=1)
   Output: id
   Index Cond: (v7.id = '018a55ff-b176-7000-bb78-04d69d360285'::uuid)
   Heap Fetches: 0
 Planning Time: 0.601 ms
 Execution Time: 0.282 ms
(6 rows)
```

And with 10 million rows:

```sql
xui=> select count(1) from v4;
  count
----------
 10000000
(1 row)

xui=> select count(1) from v7;
  count
----------
 10000000
(1 row)

xui=> explain ANALYZE VERBOSE select * from v4 where id = 'e499ad84-9756-4075-8d65-8b5874a56794';
                                                       QUERY PLAN
-------------------------------------------------------------------------------------------------------------------------
 Index Only Scan using v4_pkey on public.v4  (cost=0.43..8.45 rows=1 width=16) (actual time=2.425..2.434 rows=1 loops=1)
   Output: id
   Index Cond: (v4.id = 'e499ad84-9756-4075-8d65-8b5874a56794'::uuid)
   Heap Fetches: 0
 Planning Time: 0.522 ms
 Execution Time: 2.576 ms
(6 rows)

xui=> explain ANALYZE VERBOSE select * from v7 where id = '018a55ff-b176-7000-bb78-04d69d360285';
                                                       QUERY PLAN
-------------------------------------------------------------------------------------------------------------------------
 Index Only Scan using v7_pkey on public.v7  (cost=0.43..8.45 rows=1 width=16) (actual time=8.356..8.362 rows=1 loops=1)
   Output: id
   Index Cond: (v7.id = '018a55ff-b176-7000-bb78-04d69d360285'::uuid)
   Heap Fetches: 0
 Planning Time: 0.610 ms
 Execution Time: 8.450 ms
(6 rows)

xui=> explain ANALYZE VERBOSE select * from v4 where id = 'e499ad84-9756-4075-8d65-8b5874a56794';
                                                       QUERY PLAN
-------------------------------------------------------------------------------------------------------------------------
 Index Only Scan using v4_pkey on public.v4  (cost=0.43..8.45 rows=1 width=16) (actual time=0.750..0.754 rows=1 loops=1)
   Output: id
   Index Cond: (v4.id = 'e499ad84-9756-4075-8d65-8b5874a56794'::uuid)
   Heap Fetches: 0
 Planning Time: 12.840 ms
 Execution Time: 0.865 ms
(6 rows)

xui=> explain ANALYZE VERBOSE select * from v7 where id = '018a55ff-b176-7000-bb78-04d69d360285';
                                                       QUERY PLAN
-------------------------------------------------------------------------------------------------------------------------
 Index Only Scan using v7_pkey on public.v7  (cost=0.43..8.45 rows=1 width=16) (actual time=0.680..0.683 rows=1 loops=1)
   Output: id
   Index Cond: (v7.id = '018a55ff-b176-7000-bb78-04d69d360285'::uuid)
   Heap Fetches: 0
 Planning Time: 1.513 ms
 Execution Time: 1.104 ms
(6 rows)

xui=> explain ANALYZE VERBOSE select * from v4 where id = 'e499ad84-9756-4075-8d65-8b5874a56794';
                                                       QUERY PLAN
-------------------------------------------------------------------------------------------------------------------------
 Index Only Scan using v4_pkey on public.v4  (cost=0.43..8.45 rows=1 width=16) (actual time=0.673..0.679 rows=1 loops=1)
   Output: id
   Index Cond: (v4.id = 'e499ad84-9756-4075-8d65-8b5874a56794'::uuid)
   Heap Fetches: 0
 Planning Time: 2.574 ms
 Execution Time: 0.933 ms
(6 rows)

xui=> explain ANALYZE VERBOSE select * from v7 where id = '018a55ff-b176-7000-bb78-04d69d360285';
                                                       QUERY PLAN
-------------------------------------------------------------------------------------------------------------------------
 Index Only Scan using v7_pkey on public.v7  (cost=0.43..8.45 rows=1 width=16) (actual time=0.305..0.308 rows=1 loops=1)
   Output: id
   Index Cond: (v7.id = '018a55ff-b176-7000-bb78-04d69d360285'::uuid)
   Heap Fetches: 0
 Planning Time: 0.606 ms
 Execution Time: 0.411 ms
(6 rows)

xui=> explain ANALYZE VERBOSE select * from v4 where id = 'e499ad84-9756-4075-8d65-8b5874a56794';
                                                       QUERY PLAN
-------------------------------------------------------------------------------------------------------------------------
 Index Only Scan using v4_pkey on public.v4  (cost=0.43..8.45 rows=1 width=16) (actual time=0.572..0.574 rows=1 loops=1)
   Output: id
   Index Cond: (v4.id = 'e499ad84-9756-4075-8d65-8b5874a56794'::uuid)
   Heap Fetches: 0
 Planning Time: 0.601 ms
 Execution Time: 0.701 ms
(6 rows)

xui=> explain ANALYZE VERBOSE select * from v7 where id = '018a55ff-b176-7000-bb78-04d69d360285';
                                                       QUERY PLAN
-------------------------------------------------------------------------------------------------------------------------
 Index Only Scan using v7_pkey on public.v7  (cost=0.43..8.45 rows=1 width=16) (actual time=0.406..0.411 rows=1 loops=1)
   Output: id
   Index Cond: (v7.id = '018a55ff-b176-7000-bb78-04d69d360285'::uuid)
   Heap Fetches: 0
 Planning Time: 0.563 ms
 Execution Time: 4.945 ms
(6 rows)

xui=> explain ANALYZE VERBOSE select * from v4 where id = 'e499ad84-9756-4075-8d65-8b5874a56794';
                                                       QUERY PLAN
-------------------------------------------------------------------------------------------------------------------------
 Index Only Scan using v4_pkey on public.v4  (cost=0.43..8.45 rows=1 width=16) (actual time=2.128..2.135 rows=1 loops=1)
   Output: id
   Index Cond: (v4.id = 'e499ad84-9756-4075-8d65-8b5874a56794'::uuid)
   Heap Fetches: 0
 Planning Time: 0.967 ms
 Execution Time: 2.466 ms
(6 rows)

xui=> explain ANALYZE VERBOSE select * from v7 where id = '018a55ff-b176-7000-bb78-04d69d360285';
                                                       QUERY PLAN
-------------------------------------------------------------------------------------------------------------------------
 Index Only Scan using v7_pkey on public.v7  (cost=0.43..8.45 rows=1 width=16) (actual time=0.354..0.359 rows=1 loops=1)
   Output: id
   Index Cond: (v7.id = '018a55ff-b176-7000-bb78-04d69d360285'::uuid)
   Heap Fetches: 0
 Planning Time: 0.362 ms
 Execution Time: 0.476 ms
(6 rows)
```

Seems like v7 is not always better in 10 million rows.

Comparing INSERT performance:

Script to generate v4 UUIDs:

```js
import { randomUUID } from 'crypto'

console.log("copy v4 from stdin;")
for (let i = 0; i < 10000000; i++) {
    console.log(randomUUID() );
}
console.log("\\.")
```

Generate UUIDs, looks like v7 is slower in this case:

```sh
(base) ➜  test time node v4.js > v4.sql
node v4.js > v4  11.00s user 14.46s system 96% cpu 26.356 total
(base) ➜  test time node index.js > v7.sql
node index.js > v7  35.59s user 16.07s system 100% cpu 51.520 total
```

Import 10m rows:

```sh
(base) ➜  test time cat v4.sql | psql -h localhost -U xui xui
COPY 10000000
cat v4.sql  0.01s user 0.20s system 0% cpu 3:36.86 total
psql -h localhost -U xui xui  0.86s user 0.20s system 0% cpu 4:04.88 total

(base) ➜  test time cat v7.sql | psql -h localhost -U xui xui
COPY 10000000
cat v7.sql  0.01s user 0.14s system 0% cpu 33.888 total

psql -h localhost -U xui xui  0.84s user 0.17s system 2% cpu 36.137 total
```

Since we use UUID as primary key, each insert would check if the UUID is unique. So it's slow to INSERT. And **v7 is much more better than v4 in this case**.

As a comparision, I created a table without UNIQUE index, it's much more faster:

```sql
(base) ➜  test time cat v4.sql | psql -h localhost -U xui xui
COPY 10000000
cat v4.sql  0.01s user 0.13s system 0% cpu 16.220 total
psql -h localhost -U xui xui  0.81s user 0.19s system 5% cpu 17.174 total
```

More comparisons:

```sql
xui=> explain ANALYZE VERBOSE select * from v4 where id = '61e233d2-4ee1-4162-bcc4-764aff611a19';
                                                       QUERY PLAN
-------------------------------------------------------------------------------------------------------------------------
 Index Only Scan using v4_pkey on public.v4  (cost=0.43..4.45 rows=1 width=16) (actual time=0.321..0.323 rows=1 loops=1)
   Output: id
   Index Cond: (v4.id = '61e233d2-4ee1-4162-bcc4-764aff611a19'::uuid)
   Heap Fetches: 0
 Planning Time: 0.539 ms
 Execution Time: 0.430 ms
(6 rows)

xui=> explain ANALYZE VERBOSE select * from v7 where id = '018a5618-52e7-7003-908b-0ee433a41fa9';
                                                       QUERY PLAN
-------------------------------------------------------------------------------------------------------------------------
 Index Only Scan using v7_pkey on public.v7  (cost=0.43..4.45 rows=1 width=16) (actual time=0.182..0.184 rows=1 loops=1)
   Output: id
   Index Cond: (v7.id = '018a5618-52e7-7003-908b-0ee433a41fa9'::uuid)
   Heap Fetches: 0
 Planning Time: 0.123 ms
 Execution Time: 0.269 ms
(6 rows)

xui=> explain ANALYZE VERBOSE select * from v4 where id = '61e233d2-4ee1-4162-bcc4-764aff611a19';
                                                       QUERY PLAN
-------------------------------------------------------------------------------------------------------------------------
 Index Only Scan using v4_pkey on public.v4  (cost=0.43..4.45 rows=1 width=16) (actual time=1.282..1.284 rows=1 loops=1)
   Output: id
   Index Cond: (v4.id = '61e233d2-4ee1-4162-bcc4-764aff611a19'::uuid)
   Heap Fetches: 0
 Planning Time: 5.629 ms
 Execution Time: 1.451 ms
(6 rows)

xui=> explain ANALYZE VERBOSE select * from v7 where id = '018a5618-52e7-7003-908b-0ee433a41fa9';
                                                       QUERY PLAN
-------------------------------------------------------------------------------------------------------------------------
 Index Only Scan using v7_pkey on public.v7  (cost=0.43..4.45 rows=1 width=16) (actual time=0.231..0.233 rows=1 loops=1)
   Output: id
   Index Cond: (v7.id = '018a5618-52e7-7003-908b-0ee433a41fa9'::uuid)
   Heap Fetches: 0
 Planning Time: 0.186 ms
 Execution Time: 0.277 ms
(6 rows)

xui=> explain ANALYZE VERBOSE select * from v4 where id = '61e233d2-4ee1-4162-bcc4-764aff611a19';
                                                       QUERY PLAN
-------------------------------------------------------------------------------------------------------------------------
 Index Only Scan using v4_pkey on public.v4  (cost=0.43..4.45 rows=1 width=16) (actual time=0.114..0.116 rows=1 loops=1)
   Output: id
   Index Cond: (v4.id = '61e233d2-4ee1-4162-bcc4-764aff611a19'::uuid)
   Heap Fetches: 0
 Planning Time: 0.242 ms
 Execution Time: 0.139 ms
(6 rows)

xui=> explain ANALYZE VERBOSE select * from v7 where id = '018a5618-52e7-7003-908b-0ee433a41fa9';
                                                       QUERY PLAN
-------------------------------------------------------------------------------------------------------------------------
 Index Only Scan using v7_pkey on public.v7  (cost=0.43..4.45 rows=1 width=16) (actual time=0.188..0.194 rows=1 loops=1)
   Output: id
   Index Cond: (v7.id = '018a5618-52e7-7003-908b-0ee433a41fa9'::uuid)
   Heap Fetches: 0
 Planning Time: 0.225 ms
 Execution Time: 0.381 ms
(6 rows)
```

Remove primary key but add an index:

```sql
drop table v4;
drop table v7;
drop table v;

create table v4 (
    id UUID DEFAULT uuid_generate_v4()
);
create index idx_v4 on v4 (id);

create table v7 (
    id UUID
);
create index idx_v7 on v7 (id);
```

test:

```sh
(base) ➜  test time cat v4.sql | psql -h localhost -U xui  xui
COPY 10000000
cat v4.sql  0.01s user 0.19s system 0% cpu 3:43.83 total
psql -h localhost -U xui xui  0.86s user 0.19s system 0% cpu 4:11.44 total

(base) ➜  test time cat v7.sql | psql -h localhost -U xui  xui
COPY 10000000
cat v7.sql  0.01s user 0.14s system 0% cpu 31.078 total
psql -h localhost -U xui xui  0.83s user 0.19s system 3% cpu 33.167 total
```

Conclusion:

- v7 is a little better in SELECT with INDEX
- v7 is much better in INSERT with UNIQUE constraint (e.g. primary key) or non unique INDEX
- Since UUID is *UNIQUE*, column in database **SHOULD NOT** need to add UNIQUE constraint
- Index UUID fields for SELECT
- v7 is much more better on INSERT to indexed fields

Seems both v4 and v7 are fine as long as you don't use it with UNIQUE constraint. But v7 is still interesting to use in primary keys and you need to insert a lot of rows very fast.
