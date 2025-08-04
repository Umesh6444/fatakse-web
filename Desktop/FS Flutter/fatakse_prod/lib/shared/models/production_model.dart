import 'package:json_annotation/json_annotation.dart';

part 'production_model.g.dart';

/// ProductionModel represents a production house project, including requirements, progress, and crew.
@JsonSerializable(explicitToJson: true)
class ProductionModel {
  final String id;
  final String title;
  final ProductionRequirements requirements;
  final ProductionProgress progress;
  final List<ProductionCrewMember> crew;
  final ProductionType type;

  ProductionModel({
    required this.id,
    required this.title,
    required this.requirements,
    required this.progress,
    required this.crew,
    required this.type,
  });

  factory ProductionModel.fromJson(Map<String, dynamic> json) =>
      _$ProductionModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProductionModelToJson(this);
}

/// ProductionRequirements lists crew, equipment, and cast needed for a production.
@JsonSerializable()
class ProductionRequirements {
  final List<CrewRequirement> crew;
  final List<EquipmentRequirement> equipment;
  final List<CastRequirement> cast;
  ProductionRequirements({
    required this.crew,
    required this.equipment,
    required this.cast,
  });
  factory ProductionRequirements.fromJson(Map<String, dynamic> json) =>
      _$ProductionRequirementsFromJson(json);
  Map<String, dynamic> toJson() => _$ProductionRequirementsToJson(this);
}

/// ProductionProgress tracks milestones for a production project.
@JsonSerializable()
class ProductionProgress {
  final List<ProductionMilestone> milestones;
  ProductionProgress({required this.milestones});
  factory ProductionProgress.fromJson(Map<String, dynamic> json) =>
      _$ProductionProgressFromJson(json);
  Map<String, dynamic> toJson() => _$ProductionProgressToJson(this);
}

/// ProductionCrewMember represents a crew member and their role in a production.
@JsonSerializable()
class ProductionCrewMember {
  final String name;
  final CrewRole role;
  ProductionCrewMember({required this.name, required this.role});
  factory ProductionCrewMember.fromJson(Map<String, dynamic> json) =>
      _$ProductionCrewMemberFromJson(json);
  Map<String, dynamic> toJson() => _$ProductionCrewMemberToJson(this);
}

/// ProductionMilestone describes a milestone and its completion status in a production.
@JsonSerializable()
class ProductionMilestone {
  final String description;
  final bool completed;
  ProductionMilestone({required this.description, required this.completed});
  factory ProductionMilestone.fromJson(Map<String, dynamic> json) =>
      _$ProductionMilestoneFromJson(json);
  Map<String, dynamic> toJson() => _$ProductionMilestoneToJson(this);
}

/// CrewRequirement specifies a required crew role and count for a production.
@JsonSerializable()
class CrewRequirement {
  final CrewRole role;
  final int count;
  CrewRequirement({required this.role, required this.count});
  factory CrewRequirement.fromJson(Map<String, dynamic> json) =>
      _$CrewRequirementFromJson(json);
  Map<String, dynamic> toJson() => _$CrewRequirementToJson(this);
}

/// EquipmentRequirement specifies equipment and quantity needed for a production.
@JsonSerializable()
class EquipmentRequirement {
  final String equipmentId;
  final int quantity;
  EquipmentRequirement({required this.equipmentId, required this.quantity});
  factory EquipmentRequirement.fromJson(Map<String, dynamic> json) =>
      _$EquipmentRequirementFromJson(json);
  Map<String, dynamic> toJson() => _$EquipmentRequirementToJson(this);
}

/// CastRequirement specifies a cast role and count needed for a production.
@JsonSerializable()
class CastRequirement {
  final String role;
  final int count;
  CastRequirement({required this.role, required this.count});
  factory CastRequirement.fromJson(Map<String, dynamic> json) =>
      _$CastRequirementFromJson(json);
  Map<String, dynamic> toJson() => _$CastRequirementToJson(this);
}

/// CastingCallModel represents a casting call for a production, including status.
@JsonSerializable()
class CastingCallModel {
  final String id;
  final String description;
  final CastingStatus status;
  CastingCallModel({
    required this.id,
    required this.description,
    required this.status,
  });
  factory CastingCallModel.fromJson(Map<String, dynamic> json) =>
      _$CastingCallModelFromJson(json);
  Map<String, dynamic> toJson() => _$CastingCallModelToJson(this);
}

enum ProductionType { film, event, ad, music, other }

enum ProductionPhase { preProduction, production, postProduction }

enum CrewRole { director, producer, camera, sound, lighting, actor, other }

enum CastingStatus { open, closed, filled }
