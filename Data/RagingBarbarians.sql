-- ===========================================================================
-- Raging Barbarians & Unique Barbarians mode
-- ===========================================================================

INSERT OR REPLACE INTO CivilizationTraits (CivilizationType, TraitType) SELECT 'CIVILIZATION_BARBARIAN', 'TRAIT_CIVILIZATION_UNIT_ARABIAN_MAMLUK' 
WHERE EXISTS (SELECT * FROM Civilizations WHERE CivilizationType = 'CIVILIZATION_BARBARIAN') 
AND EXISTS (SELECT * FROM CivilizationTraits WHERE TraitType = 'TRAIT_CIVILIZATION_UNIT_ARABIAN_MAMLUK');

INSERT OR REPLACE INTO CivilizationTraits (CivilizationType, TraitType) SELECT 'CIVILIZATION_BARBARIAN', 'TRAIT_CIVILIZATION_UNIT_CREE_OKIHTCITAW' 
WHERE EXISTS (SELECT * FROM Civilizations WHERE CivilizationType = 'CIVILIZATION_BARBARIAN') 
AND EXISTS (SELECT * FROM CivilizationTraits WHERE TraitType = 'TRAIT_CIVILIZATION_UNIT_CREE_OKIHTCITAW');

INSERT OR REPLACE INTO CivilizationTraits (CivilizationType, TraitType) SELECT 'CIVILIZATION_BARBARIAN', 'TRAIT_CIVILIZATION_UNIT_AZTEC_EAGLE_WARRIOR' 
WHERE EXISTS (SELECT * FROM Civilizations WHERE CivilizationType = 'CIVILIZATION_BARBARIAN') 
AND EXISTS (SELECT * FROM CivilizationTraits WHERE TraitType = 'TRAIT_CIVILIZATION_UNIT_AZTEC_EAGLE_WARRIOR');

INSERT OR REPLACE INTO CivilizationTraits (CivilizationType, TraitType) SELECT 'CIVILIZATION_BARBARIAN', 'TRAIT_CIVILIZATION_UNIT_ETHIOPIAN_OROMO_CAVALRY' 
WHERE EXISTS (SELECT * FROM Civilizations WHERE CivilizationType = 'CIVILIZATION_BARBARIAN') 
AND EXISTS (SELECT * FROM CivilizationTraits WHERE TraitType = 'TRAIT_CIVILIZATION_UNIT_ETHIOPIAN_OROMO_CAVALRY');	

INSERT OR REPLACE INTO CivilizationTraits (CivilizationType, TraitType) SELECT 'CIVILIZATION_BARBARIAN', 'TRAIT_CIVILIZATION_UNIT_GAUL_GAESATAE' 
WHERE EXISTS (SELECT * FROM Civilizations WHERE CivilizationType = 'CIVILIZATION_BARBARIAN') 
AND EXISTS (SELECT * FROM CivilizationTraits WHERE TraitType = 'TRAIT_CIVILIZATION_UNIT_GAUL_GAESATAE');

INSERT OR REPLACE INTO CivilizationTraits (CivilizationType, TraitType) SELECT 'CIVILIZATION_BARBARIAN', 'TRAIT_CIVILIZATION_UNIT_GEORGIAN_KHEVSURETI' 
WHERE EXISTS (SELECT * FROM Civilizations WHERE CivilizationType = 'CIVILIZATION_BARBARIAN') 
AND EXISTS (SELECT * FROM CivilizationTraits WHERE TraitType = 'TRAIT_CIVILIZATION_UNIT_GEORGIAN_KHEVSURETI');	

INSERT OR REPLACE INTO CivilizationTraits (CivilizationType, TraitType) SELECT 'CIVILIZATION_BARBARIAN', 'TRAIT_CIVILIZATION_HULCHE' 
WHERE EXISTS (SELECT * FROM Civilizations WHERE CivilizationType = 'CIVILIZATION_BARBARIAN') 
AND EXISTS (SELECT * FROM CivilizationTraits WHERE TraitType = 'TRAIT_CIVILIZATION_HULCHE');	

INSERT OR REPLACE INTO CivilizationTraits (CivilizationType, TraitType) SELECT 'CIVILIZATION_BARBARIAN', 'TRAIT_CIVILIZATION_UNIT_INCA_WARAKAQ' 
WHERE EXISTS (SELECT * FROM Civilizations WHERE CivilizationType = 'CIVILIZATION_BARBARIAN') 
AND EXISTS (SELECT * FROM CivilizationTraits WHERE TraitType = 'TRAIT_CIVILIZATION_UNIT_INCA_WARAKAQ');

INSERT OR REPLACE INTO CivilizationTraits (CivilizationType, TraitType) SELECT 'CIVILIZATION_BARBARIAN', 'TRAIT_CIVILIZATION_UNIT_INDIAN_VARU' 
WHERE EXISTS (SELECT * FROM Civilizations WHERE CivilizationType = 'CIVILIZATION_BARBARIAN') 
AND EXISTS (SELECT * FROM CivilizationTraits WHERE TraitType = 'TRAIT_CIVILIZATION_UNIT_INDIAN_VARU');

INSERT OR REPLACE INTO CivilizationTraits (CivilizationType, TraitType) SELECT 'CIVILIZATION_BARBARIAN', 'TRAIT_CIVILIZATION_UNIT_KONGO_SHIELD_BEARER' 
WHERE EXISTS (SELECT * FROM Civilizations WHERE CivilizationType = 'CIVILIZATION_BARBARIAN') 
AND EXISTS (SELECT * FROM CivilizationTraits WHERE TraitType = 'TRAIT_CIVILIZATION_UNIT_KONGO_SHIELD_BEARER');

INSERT OR REPLACE INTO CivilizationTraits (CivilizationType, TraitType) SELECT 'CIVILIZATION_BARBARIAN', 'TRAIT_CIVILIZATION_UNIT_MALI_MANDEKALU_CAVALRY' 
WHERE EXISTS (SELECT * FROM Civilizations WHERE CivilizationType = 'CIVILIZATION_BARBARIAN') 
AND EXISTS (SELECT * FROM CivilizationTraits WHERE TraitType = 'TRAIT_CIVILIZATION_UNIT_MALI_MANDEKALU_CAVALRY');

INSERT OR REPLACE INTO CivilizationTraits (CivilizationType, TraitType) SELECT 'CIVILIZATION_BARBARIAN', 'TRAIT_CIVILIZATION_UNIT_MAORI_TOA' 
WHERE EXISTS (SELECT * FROM Civilizations WHERE CivilizationType = 'CIVILIZATION_BARBARIAN') 
AND EXISTS (SELECT * FROM CivilizationTraits WHERE TraitType = 'TRAIT_CIVILIZATION_UNIT_MAORI_TOA');

INSERT OR REPLACE INTO CivilizationTraits (CivilizationType, TraitType) SELECT 'CIVILIZATION_BARBARIAN', 'TRAIT_CIVILIZATION_UNIT_MAPUCHE_MALON_RAIDER' 
WHERE EXISTS (SELECT * FROM Civilizations WHERE CivilizationType = 'CIVILIZATION_BARBARIAN') 
AND EXISTS (SELECT * FROM CivilizationTraits WHERE TraitType = 'TRAIT_CIVILIZATION_UNIT_MAPUCHE_MALON_RAIDER');

INSERT OR REPLACE INTO CivilizationTraits (CivilizationType, TraitType) SELECT 'CIVILIZATION_BARBARIAN', 'TRAIT_CIVILIZATION_UNIT_NORWEGIAN_BERSERKER' 
WHERE EXISTS (SELECT * FROM Civilizations WHERE CivilizationType = 'CIVILIZATION_BARBARIAN') 
AND EXISTS (SELECT * FROM CivilizationTraits WHERE TraitType = 'TRAIT_CIVILIZATION_UNIT_NORWEGIAN_BERSERKER');

INSERT OR REPLACE INTO CivilizationTraits (CivilizationType, TraitType) SELECT 'CIVILIZATION_BARBARIAN', 'TRAIT_CIVILIZATION_UNIT_NUBIAN_PITATI'
WHERE EXISTS (SELECT * FROM Civilizations WHERE CivilizationType = 'CIVILIZATION_BARBARIAN') 
AND EXISTS (SELECT * FROM CivilizationTraits WHERE TraitType = 'TRAIT_CIVILIZATION_UNIT_NUBIAN_PITATI');

INSERT OR REPLACE INTO CivilizationTraits (CivilizationType, TraitType) SELECT 'CIVILIZATION_BARBARIAN', 'TRAIT_CIVILIZATION_UNIT_RUSSIAN_COSSACK' 
WHERE EXISTS (SELECT * FROM Civilizations WHERE CivilizationType = 'CIVILIZATION_BARBARIAN') 
AND EXISTS (SELECT * FROM CivilizationTraits WHERE TraitType = 'TRAIT_CIVILIZATION_UNIT_RUSSIAN_COSSACK');

INSERT OR REPLACE INTO CivilizationTraits (CivilizationType, TraitType) SELECT 'CIVILIZATION_BARBARIAN', 'TRAIT_CIVILIZATION_UNIT_SCOTTISH_HIGHLANDER' 
WHERE EXISTS (SELECT * FROM Civilizations WHERE CivilizationType = 'CIVILIZATION_BARBARIAN') 
AND EXISTS (SELECT * FROM CivilizationTraits WHERE TraitType = 'TRAIT_CIVILIZATION_UNIT_SCOTTISH_HIGHLANDER');

INSERT OR REPLACE INTO CivilizationTraits (CivilizationType, TraitType) SELECT 'CIVILIZATION_BARBARIAN', 'TRAIT_CIVILIZATION_UNIT_SCYTHIAN_HORSE_ARCHER' 
WHERE EXISTS (SELECT * FROM Civilizations WHERE CivilizationType = 'CIVILIZATION_BARBARIAN') 
AND EXISTS (SELECT * FROM CivilizationTraits WHERE TraitType = 'TRAIT_CIVILIZATION_UNIT_SCYTHIAN_HORSE_ARCHER');

INSERT OR REPLACE INTO CivilizationTraits (CivilizationType, TraitType) SELECT 'CIVILIZATION_BARBARIAN', 'TRAIT_CIVILIZATION_UNIT_ZULU_IMPI' 
WHERE EXISTS (SELECT * FROM Civilizations WHERE CivilizationType = 'CIVILIZATION_BARBARIAN') 
AND EXISTS (SELECT * FROM CivilizationTraits WHERE TraitType = 'TRAIT_CIVILIZATION_UNIT_ZULU_IMPI');

-- ===========================================================================
-- Default Barbarian Tribes
-- ===========================================================================

--Tags
INSERT OR REPLACE INTO Tags (Tag,	Vocabulary) 
VALUES		('CLASS_BARB_ANTICAV',				'ABILITY_CLASS'),
			('CLASS_BARB_MELEE',				'ABILITY_CLASS'),
			('CLASS_BARB_RECON',				'ABILITY_CLASS'),
			('CLASS_BARB_RANGED',				'ABILITY_CLASS'),
			('CLASS_BARB_LIGHTCAV',				'ABILITY_CLASS'),
			('CLASS_BARB_HEAVYCAV',				'ABILITY_CLASS'),
			('CLASS_BARB_SIEGE',				'ABILITY_CLASS'),
			('CLASS_BARB_NAVAL_MELEE',			'ABILITY_CLASS'),
			('CLASS_BARB_NAVAL_RANGED',			'ABILITY_CLASS'),
			('CLASS_BARB_NAVAL_RAIDER',			'ABILITY_CLASS'),
			('CLASS_BARB_SUPPORT',				'ABILITY_CLASS');
			
--TypeTags
INSERT OR REPLACE INTO TypeTags (Type,	Tag) 
VALUES		('UNIT_SPEARMAN',				'CLASS_BARB_ANTICAV'),
			('UNIT_PIKEMAN',				'CLASS_BARB_ANTICAV'),
			('UNIT_PIKE_AND_SHOT',			'CLASS_BARB_ANTICAV'),
			('UNIT_AT_CREW',				'CLASS_BARB_ANTICAV'),
			('UNIT_MODERN_AT',				'CLASS_BARB_ANTICAV');

INSERT OR REPLACE INTO TypeTags (Type,	Tag) 
VALUES		('UNIT_WARRIOR',				'CLASS_BARB_MELEE'),
			('UNIT_SWORDSMAN',				'CLASS_BARB_MELEE'),
			('UNIT_MUSKETMAN',				'CLASS_BARB_MELEE'),
			('UNIT_INFANTRY',				'CLASS_BARB_MELEE'),
			('UNIT_MECHANIZED_INFANTRY',	'CLASS_BARB_MELEE');
			
INSERT OR REPLACE INTO TypeTags (Type,	Tag) 
VALUES		('UNIT_SCOUT',					'CLASS_BARB_RECON'),
			('UNIT_SKIRMISHER',				'CLASS_BARB_RECON'),
			('UNIT_RANGER',					'CLASS_BARB_RECON'),
			('UNIT_SPEC_OPS',				'CLASS_BARB_RECON');
			
			
INSERT OR REPLACE INTO TypeTags (Type,	Tag) 
VALUES		('UNIT_SLINGER',				'CLASS_BARB_RANGED'),
			('UNIT_ARCHER',					'CLASS_BARB_RANGED'),
			('UNIT_CROSSBOWMAN',			'CLASS_BARB_RANGED'),
			('UNIT_RANGER',					'CLASS_BARB_RANGED'),
			('UNIT_FIELD_CANNON',			'CLASS_BARB_RANGED'),
			('UNIT_MACHINE_GUN',			'CLASS_BARB_RANGED');
			
INSERT OR REPLACE INTO TypeTags (Type,	Tag) 
VALUES		('UNIT_BARBARIAN_HORSEMAN',		'CLASS_BARB_LIGHTCAV'),
			('UNIT_COURSER',				'CLASS_BARB_LIGHTCAV'),
			('UNIT_CAVALRY',				'CLASS_BARB_LIGHTCAV'),
			('UNIT_HELICOPTER',				'CLASS_BARB_LIGHTCAV');
			
INSERT OR REPLACE INTO TypeTags (Type,	Tag) 
VALUES		('UNIT_HEAVY_CHARIOT',			'CLASS_BARB_HEAVYCAV'),
			('UNIT_KNIGHT',					'CLASS_BARB_HEAVYCAV'),
			('UNIT_CUIRASSIER',				'CLASS_BARB_HEAVYCAV'),
			('UNIT_TANK',					'CLASS_BARB_HEAVYCAV'),
			('UNIT_MODERN_ARMOR',			'CLASS_BARB_HEAVYCAV');
			
INSERT OR REPLACE INTO TypeTags (Type,	Tag) 
VALUES		('UNIT_CATAPULT',				'CLASS_BARB_SIEGE'),
			('UNIT_BOMBARD',				'CLASS_BARB_SIEGE'),
			('UNIT_ARTILLERY',				'CLASS_BARB_SIEGE'),
			('UNIT_ROCKET_ARTILLERY',		'CLASS_BARB_SIEGE');
			
INSERT OR REPLACE INTO TypeTags (Type,	Tag) 
VALUES		('UNIT_GALLEY',					'CLASS_BARB_NAVAL_MELEE'),
			('UNIT_CARAVEL',				'CLASS_BARB_NAVAL_MELEE'),
			('UNIT_IRONCLAD',				'CLASS_BARB_NAVAL_MELEE'),
			('UNIT_DESTROYER',				'CLASS_BARB_NAVAL_MELEE');
			
INSERT OR REPLACE INTO TypeTags (Type,	Tag) 
VALUES		('UNIT_QUADRIREME',				'CLASS_BARB_NAVAL_RANGED'),
			('UNIT_FRIGATE',				'CLASS_BARB_NAVAL_RANGED'),
			('UNIT_PRIVATEER',				'CLASS_BARB_NAVAL_RANGED'),
			('UNIT_BATTLESHIP',				'CLASS_BARB_NAVAL_RANGED'),
			('UNIT_SUBMARINE',				'CLASS_BARB_NAVAL_RANGED'),
			('UNIT_NUCLEAR_SUBMARINE',		'CLASS_BARB_NAVAL_RANGED'),
			('UNIT_MISSILE_CRUISER',		'CLASS_BARB_NAVAL_RANGED');
			
INSERT OR REPLACE INTO TypeTags (Type,	Tag) 
VALUES		('UNIT_BARBARIAN_RAIDER',		'CLASS_BARB_NAVAL_RAIDER'),
			('UNIT_PRIVATEER',				'CLASS_BARB_NAVAL_RAIDER'),
			('UNIT_SUBMARINE',				'CLASS_BARB_NAVAL_RAIDER'),
			('UNIT_NUCLEAR_SUBMARINE',		'CLASS_BARB_NAVAL_RAIDER');
			
INSERT OR REPLACE INTO TypeTags (Type,	Tag) 
VALUES		('UNIT_BATTERING_RAM',			'CLASS_BARB_SUPPORT'),
			('UNIT_SIEGE_TOWER',			'CLASS_BARB_SUPPORT'),
			('UNIT_BOMBARD',				'CLASS_BARB_SUPPORT'),
			('UNIT_ARTILLERY',				'CLASS_BARB_SUPPORT'),
			('UNIT_ROCKET_ARTILLERY',		'CLASS_BARB_SUPPORT');


--Update default BarbarianTribes
UPDATE BarbarianTribes SET MeleeTag="CLASS_BARB_MELEE" WHERE TribeType="TRIBE_MELEE";
UPDATE BarbarianTribes SET ScoutTag="CLASS_BARB_RECON" WHERE TribeType="TRIBE_MELEE";
UPDATE BarbarianTribes SET RangedTag="CLASS_BARB_RANGED" WHERE TribeType="TRIBE_MELEE";
UPDATE BarbarianTribes SET SiegeTag="CLASS_BARB_SIEGE" WHERE TribeType="TRIBE_MELEE";
UPDATE BarbarianTribes SET DefenderTag="CLASS_BARB_ANTICAV" WHERE TribeType="TRIBE_MELEE";

UPDATE BarbarianTribes SET MeleeTag="CLASS_BARB_LIGHTCAV" WHERE TribeType="TRIBE_CAVALRY";
UPDATE BarbarianTribes SET ScoutTag="CLASS_BARB_RECON" WHERE TribeType="TRIBE_CAVALRY";
-- UPDATE BarbarianTribes SET RangedTag="CLASS_MOBILE_RANGED" WHERE TribeType="TRIBE_CAVALRY"; --Default
UPDATE BarbarianTribes SET SiegeTag="CLASS_BARB_HEAVYCAV" WHERE TribeType="TRIBE_CAVALRY";
UPDATE BarbarianTribes SET DefenderTag="CLASS_BARB_ANTICAV" WHERE TribeType="TRIBE_CAVALRY";

UPDATE BarbarianTribes SET MeleeTag="CLASS_BARB_NAVAL_RAIDER" WHERE TribeType="TRIBE_NAVAL";
UPDATE BarbarianTribes SET ScoutTag="CLASS_BARB_NAVAL_MELEE" WHERE TribeType="TRIBE_NAVAL";
UPDATE BarbarianTribes SET RangedTag="CLASS_BARB_NAVAL_RANGED" WHERE TribeType="TRIBE_NAVAL";
UPDATE BarbarianTribes SET SiegeTag="CLASS_BARB_NAVAL_RANGED" WHERE TribeType="TRIBE_NAVAL";
UPDATE BarbarianTribes SET DefenderTag="CLASS_BARB_ANTICAV" WHERE TribeType="TRIBE_NAVAL";

--BarbarianAttackForces
UPDATE BarbarianAttackForces SET MeleeTag="CLASS_BARB_MELEE" WHERE AttackForceType="LowDifficultyStandardRaid";
UPDATE BarbarianAttackForces SET MeleeTag="CLASS_BARB_MELEE" WHERE AttackForceType="StandardRaid";
UPDATE BarbarianAttackForces SET MeleeTag="CLASS_BARB_MELEE" WHERE AttackForceType="HighDifficultyStandardRaid";
UPDATE BarbarianAttackForces SET MeleeTag="CLASS_BARB_MELEE" WHERE AttackForceType="LowDifficultyStandardAttack";
UPDATE BarbarianAttackForces SET MeleeTag="CLASS_BARB_MELEE" WHERE AttackForceType="StandardAttack";
UPDATE BarbarianAttackForces SET MeleeTag="CLASS_BARB_MELEE" WHERE AttackForceType="HighDifficultyStandardAttack";

-- ===========================================================================
-- New Barbarian Tribe Tags
-- ===========================================================================

--Cree
INSERT OR REPLACE INTO Tags (Tag,	Vocabulary) 
VALUES		('CLASS_BARB_CREE',				'ABILITY_CLASS');

INSERT OR REPLACE INTO TypeTags (Type,	Tag) 
VALUES		('UNIT_CREE_OKIHTCITAW',		'CLASS_BARB_CREE');

--Central African
INSERT OR REPLACE INTO Tags (Tag,	Vocabulary) 
VALUES		('CLASS_BARB_KONGO',				'ABILITY_CLASS');

INSERT OR REPLACE INTO TypeTags (Type,	Tag) 
VALUES		('UNIT_WARRIOR',				'CLASS_BARB_KONGO'),
			('UNIT_KONGO_SHIELD_BEARER',	'CLASS_BARB_KONGO'),
			('UNIT_INFANTRY',				'CLASS_BARB_KONGO');

--East African
INSERT OR REPLACE INTO Tags (Tag,	Vocabulary) 
VALUES		('CLASS_BARB_ETHIOPIAN',			'ABILITY_CLASS');

INSERT OR REPLACE INTO TypeTags (Type,	Tag) 
VALUES		('UNIT_WARRIOR',					'CLASS_BARB_ETHIOPIAN'),
			('UNIT_KONGO_SHIELD_BEARER',		'CLASS_BARB_ETHIOPIAN'),
			('UNIT_ETHIOPIAN_OROMO_CAVALRY',	'CLASS_BARB_ETHIOPIAN'),
			('UNIT_INFANTRY',					'CLASS_BARB_ETHIOPIAN');
			
--Nubian
INSERT OR REPLACE INTO Tags (Tag,	Vocabulary) 
VALUES		('CLASS_BARB_NUBIAN',			'ABILITY_CLASS');

INSERT OR REPLACE INTO TypeTags (Type,	Tag) 
VALUES		('UNIT_WARRIOR',					'CLASS_BARB_NUBIAN'),
			('UNIT_NUBIAN_PITATI',				'CLASS_BARB_NUBIAN'),
			('UNIT_UNIT_SKIRMISHER',			'CLASS_BARB_NUBIAN'),
			('UNIT_INFANTRY',					'CLASS_BARB_NUBIAN');
			
--West African
INSERT OR REPLACE INTO Tags (Tag,	Vocabulary) 
VALUES		('CLASS_BARB_MALI',			'ABILITY_CLASS');

INSERT OR REPLACE INTO TypeTags (Type,	Tag) 
VALUES		('UNIT_BARBARIAN_HORSEMAN',			'CLASS_BARB_MALI'),
			('UNIT_MALI_MANDEKALU_CAVALRY',		'CLASS_BARB_MALI'),
			('UNIT_UNIT_SKIRMISHER',			'CLASS_BARB_MALI'),
			('UNIT_HELICOPTER',					'CLASS_BARB_MALI');