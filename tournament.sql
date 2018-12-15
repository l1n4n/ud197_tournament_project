-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use it.
--
-- You can write comments in this file by starting them with two dashes, like
-- these lines here.
DROP IF EXISTS tournament;
CREATE DATABASE tournament;
\c tournament;

CREATE TABLE players (player_id serial PRIMARY KEY,
                      name VARCHAR (255) );

CREATE TABLE matches (match_id serial PRIMARY KEY,
                      winner_id INTEGER,
                      loser_id INTEGER,
                      FOREIGN KEY (winner_id) REFERENCES players (player_id),
                      FOREIGN KEY (loser_id) REFERENCES players (player_id) );


CREATE VIEW standings AS
    SELECT players.player_id, name, win.c AS win, total.c AS total
	FROM players 
			LEFT JOIN
			(SELECT player_id, COUNT(match_id) AS c
				FROM players LEFT JOIN matches
					ON player_id = winner_id
					GROUP BY player_id) AS win
			ON players.player_id = win.player_id
			LEFT JOIN
			(SELECT player_id, COUNT(match_id) AS c 
				FROM players LEFT JOIN matches 
					ON player_id IN (winner_id, loser_id)
					GROUP BY player_id) AS total
			ON players.player_id = total.player_id
			ORDER BY win DESC;

-- CREATE OR REPLACE VIEW wins AS
--   SELECT players.player_id, COUNT(matches.loser_id) AS n FROM players
--   LEFT JOIN matches ON players.player_id =  matches.winner_id
--   GROUP BY players.player_id;

-- CREATE OR REPLACE VIEW total AS
--   SELECT players.player_id, COUNT(matches.match_id) AS n FROM players
--   LEFT JOIN matches ON players.player_id = matches.winner_id
--   OR players.player_id = matches.loser_id
--   GROUP BY players.player_id;

-- CREATE OR REPLACE VIEW standings AS
--   SELECT players.player_id, players.name, wins.n AS wins, total.n AS matches_played
--       FROM players, wins, total
--       WHERE players.player_id = wins.player_id AND players.player_id = total.player_id
--       ORDER BY wins DESC;			