// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'production_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductionModel _$ProductionModelFromJson(Map<String, dynamic> json) =>
    ProductionModel(
      id: json['id'] as String,
      title: json['title'] as String,
      requirements: ProductionRequirements.fromJson(
          json['requirements'] as Map<String, dynamic>),
      progress:
          ProductionProgress.fromJson(json['progress'] as Map<String, dynamic>),
      crew: (json['crew'] as List<dynamic>)
          .map((e) => ProductionCrewMember.fromJson(e as Map<String, dynamic>))
          .toList(),
      type: $enumDecode(_$ProductionTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$ProductionModelToJson(ProductionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'requirements': instance.requirements.toJson(),
      'progress': instance.progress.toJson(),
      'crew': instance.crew.map((e) => e.toJson()).toList(),
      'type': _$ProductionTypeEnumMap[instance.type]!,
    };

const _$ProductionTypeEnumMap = {
  ProductionType.film: 'film',
  ProductionType.event: 'event',
  ProductionType.ad: 'ad',
  ProductionType.music: 'music',
  ProductionType.other: 'other',
};

ProductionRequirements _$ProductionRequirementsFromJson(
        Map<String, dynamic> json) =>
    ProductionRequirements(
      crew: (json['crew'] as List<dynamic>)
          .map((e) => CrewRequirement.fromJson(e as Map<String, dynamic>))
          .toList(),
      equipment: (json['equipment'] as List<dynamic>)
          .map((e) => EquipmentRequirement.fromJson(e as Map<String, dynamic>))
          .toList(),
      cast: (json['cast'] as List<dynamic>)
          .map((e) => CastRequirement.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProductionRequirementsToJson(
        ProductionRequirements instance) =>
    <String, dynamic>{
      'crew': instance.crew,
      'equipment': instance.equipment,
      'cast': instance.cast,
    };

ProductionProgress _$ProductionProgressFromJson(Map<String, dynamic> json) =>
    ProductionProgress(
      milestones: (json['milestones'] as List<dynamic>)
          .map((e) => ProductionMilestone.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProductionProgressToJson(ProductionProgress instance) =>
    <String, dynamic>{
      'milestones': instance.milestones,
    };

ProductionCrewMember _$ProductionCrewMemberFromJson(
        Map<String, dynamic> json) =>
    ProductionCrewMember(
      name: json['name'] as String,
      role: $enumDecode(_$CrewRoleEnumMap, json['role']),
    );

Map<String, dynamic> _$ProductionCrewMemberToJson(
        ProductionCrewMember instance) =>
    <String, dynamic>{
      'name': instance.name,
      'role': _$CrewRoleEnumMap[instance.role]!,
    };

const _$CrewRoleEnumMap = {
  CrewRole.director: 'director',
  CrewRole.producer: 'producer',
  CrewRole.camera: 'camera',
  CrewRole.sound: 'sound',
  CrewRole.lighting: 'lighting',
  CrewRole.actor: 'actor',
  CrewRole.other: 'other',
};

ProductionMilestone _$ProductionMilestoneFromJson(Map<String, dynamic> json) =>
    ProductionMilestone(
      description: json['description'] as String,
      completed: json['completed'] as bool,
    );

Map<String, dynamic> _$ProductionMilestoneToJson(
        ProductionMilestone instance) =>
    <String, dynamic>{
      'description': instance.description,
      'completed': instance.completed,
    };

CrewRequirement _$CrewRequirementFromJson(Map<String, dynamic> json) =>
    CrewRequirement(
      role: $enumDecode(_$CrewRoleEnumMap, json['role']),
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$CrewRequirementToJson(CrewRequirement instance) =>
    <String, dynamic>{
      'role': _$CrewRoleEnumMap[instance.role]!,
      'count': instance.count,
    };

EquipmentRequirement _$EquipmentRequirementFromJson(
        Map<String, dynamic> json) =>
    EquipmentRequirement(
      equipmentId: json['equipmentId'] as String,
      quantity: (json['quantity'] as num).toInt(),
    );

Map<String, dynamic> _$EquipmentRequirementToJson(
        EquipmentRequirement instance) =>
    <String, dynamic>{
      'equipmentId': instance.equipmentId,
      'quantity': instance.quantity,
    };

CastRequirement _$CastRequirementFromJson(Map<String, dynamic> json) =>
    CastRequirement(
      role: json['role'] as String,
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$CastRequirementToJson(CastRequirement instance) =>
    <String, dynamic>{
      'role': instance.role,
      'count': instance.count,
    };

CastingCallModel _$CastingCallModelFromJson(Map<String, dynamic> json) =>
    CastingCallModel(
      id: json['id'] as String,
      description: json['description'] as String,
      status: $enumDecode(_$CastingStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$CastingCallModelToJson(CastingCallModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'status': _$CastingStatusEnumMap[instance.status]!,
    };

const _$CastingStatusEnumMap = {
  CastingStatus.open: 'open',
  CastingStatus.closed: 'closed',
  CastingStatus.filled: 'filled',
};
