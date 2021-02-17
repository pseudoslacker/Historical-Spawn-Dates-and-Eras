INSERT INTO Types	(Type, Kind)
VALUES	('TRAIT_LEADER_LOYAL_HARBORS',	'KIND_TRAIT'),
		('LOYAL_HARBORS_MODIFIER_TYPE',	'KIND_MODIFIER');
		
INSERT INTO Traits	(TraitType, Name, Description)
VALUES	('TRAIT_LEADER_LOYAL_HARBORS',	'LOC_TRAIT_LEADER_LOYAL_HARBORS',	'LOC_TRAIT_LEADER_LOYAL_HARBORS_DESC');

INSERT INTO TraitModifiers		(TraitType,		ModifierId)
VALUES	('TRAIT_LEADER_LOYAL_HARBORS',	'LOYAL_HARBORS_MODIFIER');

INSERT INTO LeaderTraits (LeaderType, TraitType)
VALUES ('LEADER_DEFAULT', 'TRAIT_LEADER_LOYAL_HARBORS');

INSERT INTO	DynamicModifiers
			(ModifierType,										CollectionType,					EffectType)
VALUES		('LOYAL_HARBORS_MODIFIER_TYPE',					'COLLECTION_OWNER',				'EFFECT_ADJUST_CITY_ALWAYS_LOYAL');

INSERT INTO Modifiers 
			(ModifierId,										ModifierType,											SubjectRequirementSetId)
VALUES		('LOYAL_HARBORS_MODIFIER',				'MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER',				'REQUIRES_COASTAL_FOREIGN_CONTINENT_CITY'),
			('LOYAL_HARBORS_MODIFIER_ATTACH',		'LOYAL_HARBORS_MODIFIER_TYPE',							'REQUIRES_CITY_HAS_HARBOR');

INSERT INTO ModifierArguments
			(ModifierId,										Name,						Value)
VALUES		('LOYAL_HARBORS_MODIFIER',				'ModifierId',				'LOYAL_HARBORS_MODIFIER_ATTACH'),
			('LOYAL_HARBORS_MODIFIER_ATTACH',		'AlwaysLoyal',				1);
			
INSERT INTO RequirementSets
			(RequirementSetId,									RequirementSetType)
VALUES		('REQUIRES_COASTAL_FOREIGN_CONTINENT_CITY',				'REQUIREMENTSET_TEST_ALL'),
			('REQUIRES_CITY_HAS_HARBOR',							'REQUIREMENTSET_TEST_ALL');

INSERT INTO RequirementSetRequirements
			(RequirementSetId,									RequirementId)
VALUES		('REQUIRES_COASTAL_FOREIGN_CONTINENT_CITY',				'REQUIRES_COASTAL_CITY_LOYAL_HARBORS'),
			('REQUIRES_COASTAL_FOREIGN_CONTINENT_CITY',				'REQUIRES_CITY_IS_NOT_OWNER_CAPITAL_CONTINENT'),
			('REQUIRES_CITY_HAS_HARBOR',							'REQUIRES_CITY_HAS_HARBOR');

INSERT INTO Requirements
			(RequirementId,										RequirementType)
VALUES		('REQUIRES_COASTAL_CITY_LOYAL_HARBORS',				'REQUIREMENT_PLOT_IS_COASTAL_LAND');