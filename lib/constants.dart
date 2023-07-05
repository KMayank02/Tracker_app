final month = DateTime.now().month;
String season = "";
// int year = DateTime.now().year;

enum Seasons { fall, spring, summer, winter }

List<String> getUpcomingSeason() {
  String upcomingUrl = 'https://api.jikan.moe/v4/seasons/';
  String upcomingSeason = "";
  String upcomingSeasonImage = "";
  int year = DateTime.now().year;
  switch (month) {
    case 1:
    case 2:
    case 3:
      upcomingUrl = '$upcomingUrl$year/spring';
      upcomingSeason = 'Spring $year';
      upcomingSeasonImage = "assets/seasons/SPRING.jpg";
      break;

    case 4:
    case 5:
    case 6:
      upcomingUrl = '$upcomingUrl$year/summer';
      upcomingSeason = 'Upcoming\nSummer $year';
      upcomingSeasonImage = "assets/seasons/SUMMER.jpg";
      break;

    case 7:
    case 8:
    case 9:
      upcomingUrl = '$upcomingUrl$year/fall';
      upcomingSeason = 'Upcoming\nFall $year';
      upcomingSeasonImage = "assets/seasons/FALL.jpg";
      break;

    case 10:
    case 11:
    case 12:
      year = year + 1;
      upcomingUrl = '$upcomingUrl$year/winter';
      upcomingSeason = 'Winter $year';
      upcomingSeasonImage = "assets/seasons/WINTER.jpg";
      break;
    default:
  }
  return [
    upcomingSeason,
    upcomingSeasonImage,
    '1',
    upcomingUrl,
  ];
}

List<String> getCurrentSeason() {
  String season = '';
  String seasonImage = "";
  int year = DateTime.now().year;
  int month = DateTime.now().month;
  switch (month) {
    case 1:
    case 2:
    case 3:
      season = 'Winter $year';
      seasonImage = "assets/seasons/WINTER.jpg";
      break;

    case 4:
    case 5:
    case 6:
      season = 'Spring $year';
      seasonImage = "assets/seasons/SPRING.jpg";
      break;

    case 7:
    case 8:
    case 9:
      season = 'Summer $year';
      seasonImage = "assets/seasons/SUMMER.jpg";
      break;

    case 10:
    case 11:
    case 12:
      season = 'Fall $year';
      seasonImage = "assets/seasons/FALL.jpg";
      break;
    default:
  }
  return [season, seasonImage, '0'];
}

const animeUrl = 'https://api.jikan.moe/v4/anime';
const searchUrl = 'https://api.jikan.moe/v4/anime?q=';
const topUrl = 'https://api.jikan.moe/v4/top/anime?type=tv&limit=10';
const airingUrl = 'https://api.jikan.moe/v4/top/anime?filter=airing&type=tv';
const seasonalUrl = 'https://api.jikan.moe/v4/seasons/now?filter=tv';
const movieUrl = 'https://api.jikan.moe/v4/top/anime?type=movie';
const upcomingUrl = 'https://api.jikan.moe/v4/seasons/';
// const randomUrl = 'https://api.jikan.moe/v4/random/anime';

enum CategoryType { top, airing, season, upcoming, movie }
