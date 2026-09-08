# India Elections 2024 SQL Analysis

> A SQL-based analysis of the 2024 India General Election, exploring election results across parties, alliances, states, constituencies, candidates, and voting methods.

`SQL` · `MYSQL` · `JOINS` · `CTEs` · `WINDOW FUNCTIONS` · `SUBQUERIES` · `DATA ANALYSIS`

---

## Project Overview

This project analyzes the **2024 India General Election results** using MySQL to explore electoral performance across parties, political alliances, states, constituencies, and candidates.

The analysis examines how seats were distributed across the **NDA, I.N.D.I.A, and other parties**, while also exploring state-level results, constituency winners, candidate vote performance, victory margins, and the distribution of EVM and postal votes.

The project uses multiple related election tables and SQL techniques including **multi-table joins, aggregations, CASE statements, subqueries, CTEs, and window functions** to answer a series of election-related analytical questions.

---

## Business Questions

The analysis was designed to answer the following questions:

- How many parliamentary seats were contested, and how are they distributed across states?
- Which political alliance — **NDA, I.N.D.I.A, or Other** — won the most seats overall?
- How many seats were won by each party within the major alliances?
- How does alliance performance vary across different states?
- Which parties won the most seats within a selected state?
- Who were the **winning candidate and runner-up** in each constituency?
- Which candidates recorded the highest EVM vote totals across constituencies?
- How are **EVM and postal votes** distributed among candidates within a constituency?
- What were the total votes and victory margin for the winner of a selected constituency?
- What does the election landscape look like at the state level in terms of **seats, candidates, parties, and total votes**?

---

## Database Structure

The analysis is built on a relational database containing election results at the **candidate, constituency, party, state, and alliance levels**.

The project uses five main tables:

| Table | Purpose |
|---|---|
| **constituencywise_details** | Candidate-level results including party, EVM votes, postal votes, and total votes |
| **constituencywise_results** | Constituency-level results including the winning candidate, party, total votes, and victory margin |
| **partywise_results** | Party-level results including seats won and the alliance classification used in the analysis |
| **statewise_results** | Connects parliamentary constituencies with their respective states |
| **states** | Contains state information used for state-level analysis |

The tables are connected through identifiers such as **Constituency_ID, Parliament_Constituency, Party_ID, and State_ID**, allowing results to be analyzed across multiple levels of the election.

---

## Data Preparation

Before performing the analysis, the election data was organized and prepared for querying across multiple related tables.

The main preparation step involved creating a new **party alliance classification** in the `partywise_results` table.

Parties were grouped into three categories:

- **NDA**
- **I.N.D.I.A**
- **Other**

This classification made it possible to compare alliance performance both nationally and across individual states.

The analysis then used the relational structure of the database to connect candidate, constituency, party, and state-level information through SQL joins.

---

## SQL Analysis

The SQL analysis explores the election results from multiple perspectives, moving from national alliance performance to state, constituency, and individual candidate-level results.

### Alliance & Party Performance

The analysis compares the performance of the major political alliances and their member parties, including:

- Total seats won by **NDA**
- Total seats won by **I.N.D.I.A**
- Seats won by individual parties within each alliance
- Overall comparison between **NDA, I.N.D.I.A, and Other**
- Alliance seat distribution across individual states

### State-Level Analysis

State-level queries were used to examine:

- Number of parliamentary seats by state
- Party performance within selected states
- Alliance performance across states
- Total candidates, parties, votes, EVM votes, and postal votes for Maharashtra

### Constituency & Candidate Analysis

The analysis also drills down to individual constituencies and candidates to examine:

- Winning candidates and their respective parties
- Total votes and victory margins
- EVM and postal vote distribution
- Candidates recording the highest EVM votes within their constituencies
- Winners and runners-up across constituencies

### Winner & Runner-Up Ranking

A **CTE and `ROW_NUMBER()` window function** were used to rank candidates by total votes within each constituency.

```sql
WITH RankedCandidates AS (
    SELECT
        cd.Constituency_ID,
        cd.Candidate,
        cd.Party,
        cd.EVM_Votes,
        cd.Postal_Votes,
        cd.EVM_Votes + cd.Postal_Votes AS Total_Votes,
        ROW_NUMBER() OVER (
            PARTITION BY cd.Constituency_ID
            ORDER BY cd.EVM_Votes + cd.Postal_Votes DESC
        ) AS VoteRank
    FROM constituencywise_details cd
    JOIN constituencywise_results cr
        ON cd.Constituency_ID = cr.Constituency_ID
    JOIN statewise_results sr
        ON cr.Parliament_Constituency = sr.Parliament_Constituency
    JOIN states s
        ON sr.State_ID = s.State_ID
    WHERE s.State = 'Maharashtra'
)
SELECT
    cr.Constituency_Name,
    MAX(CASE WHEN rc.VoteRank = 1 THEN rc.Candidate END) AS Winning_Candidate,
    MAX(CASE WHEN rc.VoteRank = 2 THEN rc.Candidate END) AS Runner_Up
FROM RankedCandidates rc
JOIN constituencywise_results cr
    ON rc.Constituency_ID = cr.Constituency_ID
GROUP BY cr.Constituency_Name
ORDER BY cr.Constituency_Name;
```
<p align="center">
  <img src="assets/query_result_image" width="900">
</p>

This ranking makes it possible to identify the **winner and runner-up of each constituency** from candidate-level voting data.

---

## Key Findingshttps://github.com/belguerouidouaa-db/India-Elections-2024-SQL-Analysis/blob/main/README.md

- The election dataset covers **543 parliamentary seats** across India.

- The **NDA emerged as the largest political alliance with 292 seats**, followed by the **I.N.D.I.A alliance with 234 seats**, while parties outside the two major alliances accounted for the remaining **17 seats**.

- The **Bharatiya Janata Party (BJP)** was the largest contributor to the NDA with **240 seats**, followed by **Telugu Desam Party (TDP) with 16 seats** and **Janata Dal (United) with 12 seats**.

- Within the I.N.D.I.A alliance, the **Indian National Congress (INC)** won the most seats with **99**, followed by the **Samajwadi Party with 37**, **All India Trinamool Congress with 29**, and **DMK with 22**.

- Alliance performance varied considerably by state. The **I.N.D.I.A alliance led Uttar Pradesh with 43 seats compared with 36 for the NDA**, while the NDA dominated states such as **Madhya Pradesh with 29 seats** and **Gujarat with 25 seats**.

- **Maharashtra** recorded **48 parliamentary seats**, with the I.N.D.I.A alliance winning **30**, the NDA winning **17**, and other parties winning **1**.

- **Tamil Nadu** showed particularly strong I.N.D.I.A performance, with the alliance winning **39 seats**, while the NDA won none.

- At the individual party level in **Uttar Pradesh**, the **Samajwadi Party won 37 seats**, ahead of the **BJP with 33** and the **Indian National Congress with 6**.

- In the **Amethi constituency**, **Kishori Lal of the Indian National Congress** won with **539,228 votes** and a **victory margin of 167,196 votes**.

- Candidate-level analysis of **Mathura** showed **Hema Malini of the BJP** leading the constituency with **510,064 total votes**, including **507,535 EVM votes** and **2,529 postal votes**.

- Among the Top 10 constituency-leading candidates by EVM votes, **Rakibul Hussain in Dhubri recorded the highest total with 1,468,549 EVM votes**.

- The Maharashtra analysis covered **48 constituencies and 1,114 candidates**, with **57,179,133 total votes**, including **56,969,710 EVM votes** and **209,423 postal votes**.

---

## SQL Techniques Demonstrated

Throughout the project, several SQL techniques were used to analyze the election data across multiple levels:

- **Multi-table JOINs** to connect candidate, constituency, party, and state-level data
- **GROUP BY and aggregate functions** to calculate seat and vote totals
- **CASE statements** for political alliance classification and conditional aggregation
- **Subqueries** to identify constituency-leading candidates
- **Common Table Expressions (CTEs)** to structure more complex candidate-ranking analysis
- **Window functions** using `ROW_NUMBER()` and `PARTITION BY` to rank candidates within each constituency
- **Conditional aggregation** to compare NDA, I.N.D.I.A, and Other seat performance across states
- **Filtering and sorting** to perform targeted state and constituency-level analysis

---

## Project Files

```text
India-Elections-2024-SQL-Analysis/
│
├── README.md
├── india_elections_2024_analysis.sql

```

- **india_elections_2024_analysis.sql** — Cleaned MySQL script containing the complete election analysis, including alliance classification, party and state analysis, candidate-level queries, subqueries, CTEs, and window functions.



---

## Conclusion

This project demonstrates a structured SQL analysis workflow using a multi-table election dataset.

By combining **joins, aggregations, conditional logic, subqueries, CTEs, and window functions**, the analysis moves from national-level election results to more detailed state, constituency, and candidate-level insights.

The project demonstrates how relational data can be connected and queried to answer increasingly detailed analytical questions and extract meaningful patterns from a complex election dataset.
