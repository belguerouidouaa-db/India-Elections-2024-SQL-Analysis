
#general selection part 
select * from constituencywise_details ;
select * from constituencywise_results;
SELECT *
FROM constituencywise_results
WHERE `Constituency Name` LIKE '%MATHURA%'; 
SELECT *
FROM constituencywise_details
WHERE `Constituency ID` = 'S2520';
select * from partywise_results ;
select * from states ;
select * from statewise_results ;  

# alter and update part 
alter table constituencywise_details
add constraint Constituency_ID
foreign key (Constituency_ID)
references constituencywise_results(Constituency_ID);

alter table constituencywise_results
add constraint Parliament_Constituency
foreign key (`Parliament Constituency`)
references statewise_results(`Parliament Constituency`);

alter table  statewise_results
add constraint State_ID
foreign key (`State ID`)
references states(`State ID`);

alter table constituencywise_results
add constraint Party_ID
foreign key (`Party ID`)
references partywise_results(`Party ID`);

SET SQL_SAFE_UPDATES = 0;

SHOW CREATE TABLE constituencywise_details;

DROP TABLE constituencywise_details;
# add new column for party alliance showcase 
alter table partywise_results 
add party_alliance varchar(50);


# add INDIA ALLIANZ
update partywise_results
set party_alliance = "I.N.D.I.A" 
where party in (
    'Indian National Congress - INC',
    'Aam Aadmi Party - AAAP',
    'All India Trinamool Congress - AITC',
    'Bharat Adivasi Party - BHRTADVSIP',
    'Communist Party of India  (Marxist) - CPI(M)',
    'Communist Party of India  (Marxist-Leninist)  (Liberation) - CPI(ML)(L)',
    'Communist Party of India - CPI',
    'Dravida Munnetra Kazhagam - DMK',
    'Indian Union Muslim League - IUML',
    'Nat`Jammu & Kashmir National Conference - JKN',
    'Jharkhand Mukti Morcha - JMM',
    'Jammu & Kashmir National Conference - JKN',
    'Kerala Congress - KEC',
    'Marumalarchi Dravida Munnetra Kazhagam - MDMK',
    'Nationalist Congress Party Sharadchandra Pawar - NCPSP',
    'Rashtriya Janata Dal - RJD',
    'Rashtriya Loktantrik Party - RLTP',
    'Revolutionary Socialist Party - RSP',
    'Samajwadi Party - SP',
    'Shiv Sena (Uddhav Balasaheb Thackrey) - SHSUBT',
    'Viduthalai Chiruthaigal Katchi - VCK'
);


# add NDA allianz
update partywise_results
set party_alliance = "NDA"
where party in (
    'Bharatiya Janata Party - BJP', 
    'Telugu Desam - TDP', 
    'Janata Dal  (United) - JD(U)',
    'Shiv Sena - SHS', 
    'AJSU Party - AJSUP', 
    'Apna Dal (Soneylal) - ADAL', 
    'Asom Gana Parishad - AGP',
    'Hindustani Awam Morcha (Secular) - HAMS', 
    'Janasena Party - JnP', 
    'Janata Dal  (Secular) - JD(S)',
    'Lok Janshakti Party(Ram Vilas) - LJPRV', 
    'Nationalist Congress Party - NCP',
    'Rashtriya Lok Dal - RLD', 
    'Sikkim Krantikari Morcha - SKM'
);


# OTHER
update partywise_results 
set party_alliance = "Other"
where party_alliance is null;

#querying part 
# total seats 
select count(distinct Parliament_constituency) as Total_Seats 
from constituencywise_results;

select count(Parliament_constituency) as Total_Seats 
from statewise_results;

select count(constituency_ID) as Total_Seats 
from constituencywise_results;


# seats available for each state
select count(distinct c.Parliament_constituency) as Total_Seats, state 
from constituencywise_results c
join statewise_results s
on c.Parliament_constituency = s.Parliament_constituency
group by state;


# Total Seats Won by NDA Allianz
select sum(
    case 
        when party in (
            'Bharatiya Janata Party - BJP', 
            'Telugu Desam - TDP', 
            'Janata Dal  (United) - JD(U)',
            'Shiv Sena - SHS', 
            'AJSU Party - AJSUP', 
            'Apna Dal (Soneylal) - ADAL', 
            'Asom Gana Parishad - AGP',
            'Hindustani Awam Morcha (Secular) - HAMS', 
            'Janasena Party - JnP', 
            'Janata Dal  (Secular) - JD(S)',
            'Lok Janshakti Party(Ram Vilas) - LJPRV', 
            'Nationalist Congress Party - NCP',
            'Rashtriya Lok Dal - RLD', 
            'Sikkim Krantikari Morcha - SKM'
        ) 
        then won 
        else 0 
    end
) as NDA_Total_Seats_Won 
from partywise_results;


# Total Seats Won by NDA Allianz parties 
select party as party_name, won as seats_won 
from partywise_results 
where party in (
    'Bharatiya Janata Party - BJP', 
    'Telugu Desam - TDP', 
    'Janata Dal  (United) - JD(U)',
    'Shiv Sena - SHS', 
    'AJSU Party - AJSUP', 
    'Apna Dal (Soneylal) - ADAL', 
    'Asom Gana Parishad - AGP',
    'Hindustani Awam Morcha (Secular) - HAMS', 
    'Janasena Party - JnP', 
    'Janata Dal  (Secular) - JD(S)',
    'Lok Janshakti Party(Ram Vilas) - LJPRV', 
    'Nationalist Congress Party - NCP',
    'Rashtriya Lok Dal - RLD', 
    'Sikkim Krantikari Morcha - SKM'
)
order by won desc;


# Total Seats Won by INDIA Allianz 
select sum(
    case 
        when party in (
            'Indian National Congress - INC',
            'Aam Aadmi Party - AAAP',
            'All India Trinamool Congress - AITC',
            'Bharat Adivasi Party - BHRTADVSIP',
            'Communist Party of India  (Marxist) - CPI(M)',
            'Communist Party of India  (Marxist-Leninist)  (Liberation) - CPI(ML)(L)',
            'Communist Party of India - CPI',
            'Dravida Munnetra Kazhagam - DMK',
            'Indian Union Muslim League - IUML',
            'Nat`Jammu & Kashmir National Conference - JKN',
            'Jharkhand Mukti Morcha - JMM',
            'Jammu & Kashmir National Conference - JKN',
            'Kerala Congress - KEC',
            'Marumalarchi Dravida Munnetra Kazhagam - MDMK',
            'Nationalist Congress Party Sharadchandra Pawar - NCPSP',
            'Rashtriya Janata Dal - RJD',
            'Rashtriya Loktantrik Party - RLTP',
            'Revolutionary Socialist Party - RSP',
            'Samajwadi Party - SP',
            'Shiv Sena (Uddhav Balasaheb Thackrey) - SHSUBT',
            'Viduthalai Chiruthaigal Katchi - VCK'
        ) 
        then won 
        else 0 
    end
) as INDIA_Total_Seats 
from partywise_results;


# Total Seats Won by INDIA Allianz
select party as party_name, won as seats_won 
from partywise_results
where party in (
    'Indian National Congress - INC',
    'Aam Aadmi Party - AAAP',
    'All India Trinamool Congress - AITC',
    'Bharat Adivasi Party - BHRTADVSIP',
    'Communist Party of India  (Marxist) - CPI(M)',
    'Communist Party of India  (Marxist-Leninist)  (Liberation) - CPI(ML)(L)',
    'Communist Party of India - CPI',
    'Dravida Munnetra Kazhagam - DMK',
    'Indian Union Muslim League - IUML',
    'Nat`Jammu & Kashmir National Conference - JKN',
    'Jharkhand Mukti Morcha - JMM',
    'Jammu & Kashmir National Conference - JKN',
    'Kerala Congress - KEC',
    'Marumalarchi Dravida Munnetra Kazhagam - MDMK',
    'Nationalist Congress Party Sharadchandra Pawar - NCPSP',
    'Rashtriya Janata Dal - RJD',
    'Rashtriya Loktantrik Party - RLTP',
    'Revolutionary Socialist Party - RSP',
    'Samajwadi Party - SP',
    'Shiv Sena (Uddhav Balasaheb Thackrey) - SHSUBT',
    'Viduthalai Chiruthaigal Katchi - VCK'
)
order by won desc;

# Which party alliance (NDA, I.N.D.I.A, or OTHER) won the most seats across all states? 
select party_alliance as "Top1 Alliance", sum(won) as "seats won" 
from partywise_results 
group by party_alliance 
order by sum(won) desc 
limit 1;


# Winning candidate's name, their party name, total votes, and the margin of victory for a specific state and constituency name
select cr.winning_candidate, pr.party, cr.total_votes, cr.margin 
from constituencywise_results cr
join partywise_results pr 
    on pr.party_id = cr.party_id 
join statewise_results sr 
    on sr.Parliament_constituency = cr.Parliament_constituency 
join states s 
    on sr.State_ID = s.State_ID
where s.state = 'Uttar Pradesh' 
and cr.constituency_name = 'AMETHI';


# What is the distribution of EVM votes versus postal votes for candidates in a specific constituency?
select cd.evm_votes, cd.postal_votes, cd.total_votes, cd.candidate, cr.constituency_name 
from constituencywise_details cd 
join constituencywise_results cr 
    on cd.Constituency_ID = cr.Constituency_ID 
where cr.Constituency_Name = 'UDHAMPUR' 
order by cd.total_votes desc;


# Which parties won the most seats in a State, and how many seats did each party win?
select count(cr.constituency_id) as Seats, pr.party
from constituencywise_results cr
join statewise_results sr 
    on cr.Parliament_Constituency = sr.Parliament_Constituency
join states s 
    on sr.State_ID = s.State_ID
join partywise_results pr 
    on cr.party_id = pr.party_id
where s.state = 'Uttar Pradesh'
group by pr.party
order by Seats desc;

# What is the total number of seats won by each party alliance (NDA, I.N.D.I.A, and OTHER) in each state for the India Elections 2024
select sum(case when party_alliance = "NDA" then 1 else 0 end) as NDA_Seats_Won , 
sum(case when party_alliance = "I.N.D.I.A" then 1 else 0 end) as INDIA_Seats_Won ,
sum(case when party_alliance = "Other" then 1 else 0 end) as Other_Seats_Won, s.state 
from constituencywise_results cr
join partywise_results pr on cr.Party_ID = pr.party_id
join statewise_results sr on cr.Parliament_Constituency = sr.Parliament_Constituency
join states s on s.state_id = sr.state_id 
group by  s.state 
order by s.state asc  ;

#Which candidate received the highest number of EVM votes in each constituency (Top 10)?
select cd.candidate ,cr.Constituency_Name , cd.EVM_Votes
from constituencywise_details cd
join constituencywise_results cr on cd.Constituency_id = cr.Constituency_ID
where cd.EVM_Votes = (select max(cd1.EVM_Votes) from constituencywise_details cd1 where cd1.Constituency_id = cd.Constituency_id)
order by cd.EVM_Votes desc
limit 10 ;

#Which candidate won and which candidate was the runner-up(secondplace) in each constituency of State for the 2024 elections?TO REPEAT
with rankedcandidates as (select cd.Constituency_ID,
        cd.Candidate,
        cd.Party,
        cd.EVM_Votes,
        cd.Postal_Votes,
        cd.EVM_Votes + cd.Postal_Votes AS Total_Votes,
        row_number() over (partition by cd.Constituency_ID order by cd.EVM_Votes + cd.Postal_Votes desc ) as VoteRank 
        from    constituencywise_details cd
    JOIN 
        constituencywise_results cr ON cd.Constituency_ID = cr.Constituency_ID
    JOIN 
        statewise_results sr ON cr.Parliament_Constituency = sr.Parliament_Constituency
    JOIN 
        states s ON sr.State_ID = s.State_ID
     where s.state='Maharashtra' )
select cr.Constituency_Name,
       max(case when rc.voterank = 1 then rc.candidate end) as Winning_Candidate ,
       max(case when rc.voterank = 2 then rc.candidate end ) as running_candidate
       FROM 
    RankedCandidates rc
JOIN 
    constituencywise_results cr ON rc.Constituency_ID = cr.Constituency_ID
    group by cr.Constituency_Name
    order by cr.Constituency_Name ;
     
#For the state of Maharashtra, what are the total number of seats, total number of candidates, total number of parties, total votes (including EVM and postal), and the breakdown of EVM and postal votes?
select count(distinct(cr.Constituency_ID)) as Total_Seats , count(cd.candidate) as Total_candidates  , count(distinct(p.party)) as Total_Parties ,     SUM(cd.EVM_Votes + cd.Postal_Votes) AS Total_Votes,  SUM(cd.EVM_Votes) AS Total_EVM_Votes,
    SUM(cd.Postal_Votes) AS Total_Postal_Votes
FROM constituencywise_results cr
JOIN 
    constituencywise_details cd ON cr.Constituency_ID = cd.Constituency_ID
JOIN 
    statewise_results sr ON cr.Parliament_Constituency = sr.Parliament_Constituency
JOIN 
    states s ON sr.State_ID = s.State_ID
JOIN 
    partywise_results p ON cr.Party_ID = p.Party_ID
where s.state='Maharashtra' ;





            

            
            

                




