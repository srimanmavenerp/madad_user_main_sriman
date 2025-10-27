class EligibleDates {
  String? bookingId;
  List<EligibleMonths>? eligibleMonths;
  List<String>? selectedDates;

  EligibleDates({
    this.bookingId,
    this.eligibleMonths,
    this.selectedDates,
  });

  EligibleDates.fromJson(Map<String, dynamic> json) {
    bookingId = json['booking_id'];
    if (json['eligible_months'] != null) {
      eligibleMonths = (json['eligible_months'] as List)
          .map((v) => EligibleMonths.fromJson(v))
          .toList();
    }
    selectedDates = (json['selected_dates'] as List?)?.cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['booking_id'] = bookingId;
    if (eligibleMonths != null) {
      data['eligible_months'] = eligibleMonths!.map((v) => v.toJson()).toList();
    }
    data['selected_dates'] = selectedDates;
    return data;
  }
}

class EligibleMonths {
  String? month;
  SelectedDateRange? selectedDateRange;

  EligibleMonths({
    this.month,
    this.selectedDateRange,
  });

  EligibleMonths.fromJson(Map<String, dynamic> json) {
    month = json['month'];
    selectedDateRange = json['range'] != null
        ? SelectedDateRange.fromJson(json['range'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['month'] = month;
    if (selectedDateRange != null) {
      data['range'] = selectedDateRange!.toJson();
    }
    return data;
  }
}

class SelectedDateRange {
  String? start;
  String? end;

  SelectedDateRange({
    this.start,
    this.end,
  });

  SelectedDateRange.fromJson(Map<String, dynamic> json) {
    start = json['start'];
    end = json['end'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['start'] = start;
    data['end'] = end;
    return data;
  }
}
