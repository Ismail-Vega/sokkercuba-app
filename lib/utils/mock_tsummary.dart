import '../models/tsummary/tsummary.dart';

const Map<String, dynamic> mockTSummaryJson = {
  "weeks": [
    {
      "gameDay": {
        "season": 70,
        "week": 1096,
        "seasonWeek": 4,
        "day": 5,
        "date": {"value": "2024-07-11", "timestamp": 1720681200}
      },
      "week": 1096,
      "stats": {"general": 12, "advanced": 0, "skillsUp": 0},
      "juniors": {"number": 9, "skillsUp": 0}
    },
    {
      "gameDay": {
        "season": 70,
        "week": 1095,
        "seasonWeek": 3,
        "day": 5,
        "date": {"value": "2024-07-04", "timestamp": 1720076400}
      },
      "week": 1095,
      "stats": {"general": 2, "advanced": 10, "skillsUp": 7},
      "juniors": {"number": 9, "skillsUp": 3}
    },
    {
      "gameDay": {
        "season": 70,
        "week": 1094,
        "seasonWeek": 2,
        "day": 5,
        "date": {"value": "2024-06-27", "timestamp": 1719471600}
      },
      "week": 1094,
      "stats": {"general": 3, "advanced": 10, "skillsUp": 5},
      "juniors": {"number": 11, "skillsUp": 4}
    },
    {
      "gameDay": {
        "season": 70,
        "week": 1093,
        "seasonWeek": 1,
        "day": 5,
        "date": {"value": "2024-06-20", "timestamp": 1718866800}
      },
      "week": 1093,
      "stats": {"general": 3, "advanced": 10, "skillsUp": 3},
      "juniors": {"number": 10, "skillsUp": 7}
    },
    {
      "gameDay": {
        "season": 69,
        "week": 1092,
        "seasonWeek": 13,
        "day": 5,
        "date": {"value": "2024-06-13", "timestamp": 1718262000}
      },
      "week": 1092,
      "stats": {"general": 3, "advanced": 10, "skillsUp": 2},
      "juniors": {"number": 10, "skillsUp": 7}
    },
    {
      "gameDay": {
        "season": 69,
        "week": 1091,
        "seasonWeek": 12,
        "day": 5,
        "date": {"value": "2024-06-06", "timestamp": 1717657200}
      },
      "week": 1091,
      "stats": {"general": 3, "advanced": 10, "skillsUp": 5},
      "juniors": {"number": 11, "skillsUp": 5}
    }
  ]
};

final TSummary mockTSummary = TSummary.fromJson(mockTSummaryJson);
