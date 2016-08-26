/* Formatted on 16.06.2016 9:43:05 AM (QP5 v5.185.11230.41888) */
CREATE OR REPLACE FORCE VIEW BA_CONTRACT_KEYS_Q1
(
   TYPE_ID,
   KEY_ID,
   SHORTNAME
)
AS
   SELECT 'TRANSPORT' type_id, transport_id key_id, shortname
     FROM ba_contract_transports
   UNION ALL
   SELECT 'ACCIZA' type_id, excise_id GROUP_ID, shortname
     FROM ba_contract_excises
   UNION ALL
   SELECT 'DISTRIBUTIE' type_id, distribution_id GROUP_ID, shortname
     FROM ba_contract_distributions;


/* Formatted on 16.06.2016 9:43:05 AM (QP5 v5.185.11230.41888) */
CREATE OR REPLACE FORCE VIEW CL_CONTRACT_COSTS_Q2
(
   TYPE_ID,
   COST_KEY,
   GROUP_ID,
   COST_VALUE,
   VALID_FROM,
   VALID_ORDER
)
AS
   SELECT /*+RULE*/
         type_id,
          cost_key,
          GROUP_ID,
          cost_value,
          valid_from,
          RANK ()
          OVER (PARTITION BY type_id, cost_key, GROUP_ID
                ORDER BY valid_from DESC)
             valid_order
     FROM cl_contract_costs
    WHERE TRUNC (valid_from) <= TRUNC (SYSDATE);


/* Formatted on 16.06.2016 9:43:05 AM (QP5 v5.185.11230.41888) */
CREATE OR REPLACE FORCE VIEW CL_CONTRACT_PRICES_Q2
(
   PRODUCT_ID,
   GROUP_ID,
   PRICE,
   VALID_FROM,
   VALID_ORDER,
   CURRENCY_ID
)
AS
   SELECT /*+RULE*/
         product_id,
          GROUP_ID,
          price,
          valid_from,
          RANK ()
          OVER (PARTITION BY product_id, GROUP_ID ORDER BY valid_from DESC)
             valid_order,
          CURRENCY
     FROM cl_contract_prices
    WHERE TRUNC (valid_from) <= TRUNC (SYSDATE);
