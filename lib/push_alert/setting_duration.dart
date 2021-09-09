
final Map<String, dynamic> week = {
  '월': 1,
  '화': 2,
  '수': 3,
  '목': 4,
  '금': 5,
  '토': 6,
  '일': 7,
  '주말': [6,7],
  '평일': List<int>.generate(5, (index) => index + 1),
  '매일': [24],
};

class SettingDuration {

  List<String> getWeekDays(String summary){
    if(summary.contains('주말')) {
      return ['토', '일'];
    } else if(summary.contains('평일')) {
      return ['월','화', '수', '목', '금'];
    } else if(summary.contains('매일')) {
      return ['월','화', '수', '목', '금', '토', '일'];
    } else throw Exception('파라미터 확인하세요.');
  }

  List<int> getDays(String cycle) {
    if(cycle.contains(',')) {
      return cycle.split(', ').map((e) => week[e]).cast<int>().toList();
    } else {
      switch(cycle) {
        case '평일': return week['평일'] as List<int>;
        case '주말': return week['주말'] as List<int>;
        case '매일': return week['매일'] as List<int>;
        default: {
          int value = week[cycle] as int;
          return [value];
        }
      }
    }
  }

  Duration getDurationIfOneDay(int value, int year, int month, int day, int weekday, int absoluteHour, int absoluteMinute, DateTime now){
    print('value: $value / $year-$month-$day ($weekday) / time- $absoluteHour:$absoluteMinute / now: $now');
    var duration;
    if(value == 24) {
      duration = DateTime(year, month, day+1, absoluteHour, absoluteMinute).difference(now);
    } else {
      var targetWeekDay = value;
      if(weekday == targetWeekDay) {
        if(DateTime(year, month, day, absoluteHour, absoluteMinute).compareTo(now) > 0) {
          duration = DateTime(year, month, day, absoluteHour, absoluteMinute).difference(now);
        } else duration = DateTime(year, month, day+7, absoluteHour, absoluteMinute).difference(now);
      }
      else if(weekday > targetWeekDay) {
        switch(weekday) {
          case 7: {
            duration = DateTime(year, month, day + targetWeekDay, absoluteHour, absoluteMinute).difference(now);
            break;
          }
          case 6: {
            duration = DateTime(year, month, day + targetWeekDay + 1, absoluteHour, absoluteMinute).difference(now);
            break;
          }
          case 5: {
            duration = DateTime(year, month, day + targetWeekDay + 2, absoluteHour, absoluteMinute).difference(now);
            break;
          }
          case 4: {
            duration = DateTime(year, month, day + targetWeekDay + 3, absoluteHour, absoluteMinute).difference(now);
            break;
          }
          case 3: {
            duration = DateTime(year, month, day + targetWeekDay + 4, absoluteHour, absoluteMinute).difference(now);
            break;
          }
          case 2: {
            duration = DateTime(year, month, day + targetWeekDay + 5, absoluteHour, absoluteMinute).difference(now);
            break;
          }
        }
      } else if(weekday < targetWeekDay) {
        duration = DateTime(year, month, day + (targetWeekDay - weekday), absoluteHour, absoluteMinute).difference(now);
      }
    }
    print('duration: $duration');
    return duration;
  }
}

var diff = SettingDuration();
