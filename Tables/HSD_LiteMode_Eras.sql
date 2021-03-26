/*

	Historical Spawn Dates
	by Gedemon (2013-2017)

*/

-------------------------------------------------------------------------------
-- Historical Spawn Eras - LITE MODE
-- 0 - Ancient Era
-- 1 - Classical Era
-- 2 - Medieval Era
-- 3 - Renaissance Era
-- 4 - Industrial Era
-- 5 - Modern Era
-- 6 - Atomic Era
-- 7 - Digital Era
-- 8 - Future Era
-------------------------------------------------------------------------------
INSERT OR REPLACE INTO HistoricalSpawnEras_LiteMode
(	Civilization,				Era) 
VALUES
-- Major Civilizations
(	'CIVILIZATION_AMERICA',				4 ),
(	'CIVILIZATION_ARABIA',				0 ),
(	'CIVILIZATION_AUSTRALIA',			4 ),
(	'CIVILIZATION_AZTEC',				2 ),
(	'CIVILIZATION_BABYLON_STK',			0 ),
(	'CIVILIZATION_BRAZIL',				4 ),
(	'CIVILIZATION_BYZANTIUM',			0 ),
(	'CIVILIZATION_CANADA',		 	 	4 ),
(	'CIVILIZATION_CHINA',				0 ),
(	'CIVILIZATION_CREE',				2 ),
(	'CIVILIZATION_ENGLAND',				0 ),
(	'CIVILIZATION_EGYPT',				0 ),
(	'CIVILIZATION_ETHIOPIA',			0 ),
(	'CIVILIZATION_FRANCE',				0 ),
(	'CIVILIZATION_GAUL',				0 ),
(	'CIVILIZATION_GEORGIA',				0 ),
(	'CIVILIZATION_GERMANY',				0 ),
(	'CIVILIZATION_GRAN_COLOMBIA',		4 ),
(	'CIVILIZATION_GREECE',				0 ),
(	'CIVILIZATION_HUNGARY',				0 ),
(	'CIVILIZATION_INCA',				2 ),
(	'CIVILIZATION_INDIA',				0 ),
(	'CIVILIZATION_INDONESIA',			0 ),
(	'CIVILIZATION_JAPAN',				0 ),
(	'CIVILIZATION_KHMER',				0 ),
(	'CIVILIZATION_KONGO',				0 ),
(	'CIVILIZATION_KOREA',				0 ),
(	'CIVILIZATION_MAPUCHE',				2 ),
(	'CIVILIZATION_MACEDON',				0 ),
(	'CIVILIZATION_MALI',				0 ),
(	'CIVILIZATION_MAORI',		 		2 ),
(	'CIVILIZATION_MAYA',		 		2 ),
(	'CIVILIZATION_MONGOLIA',			0 ),
(	'CIVILIZATION_NETHERLANDS',			0 ),
(	'CIVILIZATION_NORWAY',				0 ),
(	'CIVILIZATION_NUBIA',				0 ),
(	'CIVILIZATION_OTTOMAN',				0 ),
(	'CIVILIZATION_PERSIA',				0 ),
(	'CIVILIZATION_PHOENICIA',			0 ),
(	'CIVILIZATION_POLAND',				0 ),
(	'CIVILIZATION_PORTUGAL',			0 ),
(	'CIVILIZATION_ROME',				0 ),
(	'CIVILIZATION_RUSSIA',				0 ),
(	'CIVILIZATION_SCOTLAND',			0 ),
(	'CIVILIZATION_SCYTHIA',				0 ),
(	'CIVILIZATION_SPAIN',				0 ),
(	'CIVILIZATION_SUMERIA',				0 ),
(	'CIVILIZATION_SWEDEN',				0 ),
(	'CIVILIZATION_VIETNAM',				0 ),
(	'CIVILIZATION_ZULU',				0 ),
-- Minor Civilizations
(	'CIVILIZATION_AKKAD',				0 ),
(	'CIVILIZATION_AMSTERDAM',			0 ),
(	'CIVILIZATION_ANTANANARIVO',		0 ),
(	'CIVILIZATION_ANTIOCH',				0 ),
(	'CIVILIZATION_ARMAGH',				0 ),
(	'CIVILIZATION_AUCKLAND',			4 ),
(	'CIVILIZATION_BABYLON',				0 ),
(	'CIVILIZATION_BOLOGNA',		 		0 ),
(	'CIVILIZATION_BRUSSELS',			0 ),
(	'CIVILIZATION_BUENOS_AIRES',		4 ),
(	'CIVILIZATION_CAGUANA',				2 ),
(	'CIVILIZATION_CAHOKIA',				2 ),
(	'CIVILIZATION_CARDIFF',		 		0 ),
(	'CIVILIZATION_FEZ',		  			0 ),
(	'CIVILIZATION_GENEVA',				0 ),
(	'CIVILIZATION_GRANADA',				0 ),
(	'CIVILIZATION_HATTUSA',				0 ),
(	'CIVILIZATION_HUNZA',				1 ),
(	'CIVILIZATION_HONG_KONG',			0 ),
(	'CIVILIZATION_JAKARTA',				0 ),
(	'CIVILIZATION_JERUSALEM',			0 ),
(	'CIVILIZATION_KABUL',				0 ),
(	'CIVILIZATION_KANDY',				0 ),
(	'CIVILIZATION_KUMASI',				0 ),
(	'CIVILIZATION_LAHORE',				0 ),
(	'CIVILIZATION_LA_VENTA',			1 ),
(	'CIVILIZATION_LHASA',				0 ),
(	'CIVILIZATION_LISBON',				0 ),
(	'CIVILIZATION_MEXICO_CITY',			4 ),
(	'CIVILIZATION_MOHENJO_DARO',		0 ),
(	'CIVILIZATION_MUSCAT',				0 ),
(	'CIVILIZATION_NAN_MADOL',			1 ),
(	'CIVILIZATION_NAZCA',		 		1 ),
(	'CIVILIZATION_NGAZARGAMU',			0 ),
(	'CIVILIZATION_PALENQUE',			1 ),
(	'CIVILIZATION_PRESLAV',				0 ),
(	'CIVILIZATION_RAPA_NUI',			2 ),
(	'CIVILIZATION_SEOUL',				0 ),
(	'CIVILIZATION_SINGAPORE',			0 ),
(	'CIVILIZATION_STOCKHOLM',			0 ),
(	'CIVILIZATION_TARUGA',				0 ),
(	'CIVILIZATION_TORONTO',				4 ),
(	'CIVILIZATION_VALLETTA',			0 ),
(	'CIVILIZATION_VATICAN_CITY',		0 ),
(	'CIVILIZATION_VILNIUS',				0 ),
(	'CIVILIZATION_YEREVAN',				0 ),
(	'CIVILIZATION_ZANZIBAR',			0 ),
--Babylon DLC City States
(	'CIVILIZATION_AYUTTHAYA',			0 ),	
(	'CIVILIZATION_CHINGUETTI',		 	0 ),	
(	'CIVILIZATION_JOHANNESBURG',		0 ),
(	'CIVILIZATION_NALANDA',		 		0 ),
(	'CIVILIZATION_SAMARKAND',		 	0 ),
(	'CIVILIZATION_WOLIN',		 		0 ),
(	'END_OF_INSERT',				NULL	);	
-- Remove "END_OF_INSERT" entry 
DELETE from HistoricalSpawnEras_LiteMode WHERE Civilization ='END_OF_INSERT';

--End