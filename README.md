# rechonest
R Interface to Access Echo Nest API

[![rstudio mirror downloads](http://cranlogs.r-pkg.org/badges/rechonest)](https://github.com/metacran/cranlogs.app)
[![cran version](http://www.r-pkg.org/badges/version/rechonest)](http://cran.rstudio.com/web/packages/rechonest)


## Echo Nest API
The Echo Nest offers an incredible array of music data and services for developers to build amazing apps and experiences. Hundreds of music applications tap into The Echo Nest API for access to billions of data points about music from leading media companies (MTV, the BBC, MOG and others) to award-winning mobile applications (Discovr, Music Hunter, Pocket Hipster). This package covers most of the API endpoints.

## Registering for an API key
We need an API key in every API call. To get an API key, we need to create an Echo Nest developer account.To get API key click [here](http://developer.echonest.com/account/register)

## Installation
To install from CRAN:
```R
install.packages("rechonest")
```

To install the latest development:
```R
library(devtools)
install_github("mukul13/rechonest")
```

## rechonest in action
To check all types of functions this package supports:
```R
library(rechonest)
ls("package:rechonest")

##  [1] "basic_playlist"           "extract_artist_names"     "get_artist_biographies"  
##  [4] "get_artist_blogs"         "get_artist_data"          "get_artist_familiarity"  
##  [7] "get_artist_hotttnesss"    "get_artist_images"        "get_artist_news"         
## [10] "get_artist_reviews"       "get_artist_songs"         "get_artist_terms"        
## [13] "get_artist_videos"        "get_genre_info"           "get_top_genre_artists"   
## [16] "get_top_hottt"            "get_top_terms"            "get_twitter_handle"      
## [19] "list_genres"              "list_terms"               "search_artist"           
## [22] "search_genre"             "search_songs"             "similar_artists"         
## [25] "similar_genres"           "standard_static_playlist" "suggest_artist_names"   
```

### 1. search_artist
 To search artist by using artist name.
 
<b>Name, Description:</b> One of name or description is required, but only one can be used in a query at one time.

<b>Sort options:</b> familiarity-asc, hotttnesss-asc, familiarity-desc, hotttnesss-desc, artist_start_year-asc, 
artist_start_year-desc, artist_end_year-asc, artist_end_year-desc.

<b>Years Active:</b> Term "present" can be used to indicate an artist that is still active.

<b>Description, Style, Mood:</b>  Each description style or mood term must be in its own parameter. Terms can be boosted. To boost a term use the caret, "^", symbol with a boost factor (a number) at the end of the term you are searching. The higher the boost factor, the more relevant the term will be. To prohibit a term from appearing in the result artists, prepend, a "-". To require a term, prepend a '+' (which must be encoded as %2b) or alternatively, to avoid having to encode the plus you can prepend a '^'.

<b>Examples:</b>

```R
### Artist name
data1=search_artist(api_key,name="coldplay")

### using style and artist's end year detail
data2=search_artist(api_key,style="rock",artist_end_year_after = "present",results=36)

### using mood,description,style,sort,max and min hotttnesss
data3=search_artist(api_key,mood = "happy",description = "heavy",style="rock",max_hotttnesss = 0.9,min_hotttnesss = 0.7,sort = "hotttnesss-desc",results = 56)

### using artist location and rank type
data4=search_artist(api_key,artist_location = "country:india",rank_type = "familiarity",results = 25)
```

### 2. similar_artists
To search similar artists by using names or IDs.

<b>Boosting:</b> This method can take multiple seed artists. You an give a seed artist more or less weight by boosting the artist. A boost is an affinity for a seed that gives it more or less weight when making calculations based on the argument. In case seeds are not meant to be equally valued, the boost can help clarify where along a spectrum each argument falls. The boost is a positive floating point value, where 1 gives the normal weight. It is signified by appending a caret and weight to the argument.

<b>Examples:</b>

```R
### using artist names
data1=similar_artists(api_key,name=c("adele","maroon 5"),results=36)

### using artist IDs
data2=similar_artists(api_key,id=c("AR73S4G1187B9A03C2","AR9P7FS1187B9A641F","ARIL5841187FB5C061","ARKMQ0K11C8A4224DF","ARS57XV1187B9B8535"),results=36)

### using boosting
data3=similar_artists(api_key,name=c("linkin park^2.5","maroon 5"))
```

### 3. get_artist_data
To get artist's information in single API call.

<b>Examples:</b>

```R
### using artist name and terms
data1=get_artist_data(api_key,name="coldplay",terms=T)

### using artist name,partner catalog, news, blogs, biographies 
data2=get_artist_data(api_key,name="coldplay",partner ="spotify", news=T,blogs=T,biographies = T)

### using artist name doc counts and urls
data3=get_artist_data(api_key,name="coldplay",doc_counts = T,urls = T)
```

### 4. get_artist_blogs:
To get artist's blogs.

<b>Examples:</b>

```R
### using artist ID
data1=get_artist_blogs(api_key,id="ARJ7KF01187B98D717",results = 31,start=5)

### to get relevant articles
data2=get_artist_blogs(api_key,name="adele",results = 99,high_relevance = T)
```

### 5. get_artist_news:
To get news related to artist.

<b>Examples:</b>

```R
### using artist ID
data1=get_artist_news(api_key,id="ARJ7KF01187B98D717",start=100,results = 13)

### to get relevant articles
data2=get_artist_news(api_key,name="adele",results = 66,high_relevance = T)
```

### 6. get_artist_reviews:
To get reviews about artist.

<b>Examples:</b>

```R
### using artist ID
data1=get_artist_reviews(api_key,id="ARJ7KF01187B98D717",results = 80,start=6)

### using artist name
data2=get_artist_reviews(api_key,name="adele",results = 31)
```

### 7. get_artist_biographies:
To get a list of artist biographies.

<b>license options:</b> echo-source, all-rights-reserved, cc-by-sa, cc-by-nc, cc-by-nc-nd, cc-by-nc-sa,               
cc-by-nd, cc-by, public-domain, unknown

<b>Examples:</b>

```R
### using artist ID
data1=get_artist_biographies(api_key,id="ARJ7KF01187B98D717",results = 11,start=2)

### using artist name
data2=get_artist_biographies(api_key,name="adele",results = 15)
```

### 8. get_artist_images:
To get artist's images.

<b>Examples:</b>

```R
### using name and to get first 50 results
data1=get_artist_images(api_key,name="maroon 5",start=0,results=50)

### to get next 50 results
data2=get_artist_images(api_key,name="maroon 5",start=50,results=50)
```

### 9. get_artist videos:
To get a list of video documents found on the web related to an artist.

<b>Examples:</b>

```R
### using artist ID
data1=get_artist_videos(api_key,id="ARJ7KF01187B98D717",results = 31,start=10)

### using artist name
data2=get_artist_videos(api_key,name="adele",results = 11)
```

### 10. get_artist_songs:
To get artist's songs.

<b>Examples:</b>

```R
### using artist ID
data1=get_artist_songs(api_key,id="ARJ7KF01187B98D717",results = 31,start=50)

### using artist name
data2=get_artist_songs(api_key,name="adele",results = 11)
```

### 11. get_artist_terms:
To get artist's terms.

<b>Examples:</b>

```R
### using artist ID
data1=get_artist_terms(api_key,id="ARJ7KF01187B98D717")

### using artist name
data2=get_artist_terms(api_key,name="adele")
```

### 12. get_artist_hotttnesss and get_artist_familiarity:
To get artist' hotttnesss and faniliarity.

<b>Examples:</b>

```R
### to get hotttnesss
data1=get_artist_hotttnesss(api_key,id="ARJ7KF01187B98D717")

### to get familiarity
data2=get_artist_familiarity(api_key,name="adele")
```

### 13. extract_artist_names:
To extract artist names from text.

<b>Examples:</b>

```R
### to get artist's name from text
data1=extract_artist_names(api_key,text="Coldplay is way better than maroon 5")

### using min_hotttnesss
data2=extract_artist_names(api_key,text="Coldplay is way better than maroon 5",min_hotttnesss = 0.9)
```

### 14. suggest_artist_names:
To suggest artists based upon partial names.

<b>Example:</b>      

```R
### to get suggestions
data=suggest_artist_names(api_key,name="cold")
```

### 15. get_twitter_handle:
To get the twitter handle for an artist

<b>Example:</b>

```R
### using artist name
data=get_twitter_handle(api_key,name="coldplay")
```

### 16. list_genres and list_terms:
To get genre's list and best typed descriptive terms.

<b>Examples:</b>

```R
### to list genres
list_genres(api_key)

### to list descriptive terms
list_terms(api_key)
```

### 17. get_top_hottt and get_top_terms:
To return a list of the top hottt artists and a list of the overall top terms.

<b>Examples:</b>

```R
### get top hottt artists
data1=get_top_hottt(api_key)

### using genre
data2=get_top_hottt(api_key,genre="pop",results=33)

### to get top terms 
data3=get_top_terms(api_key)
```

### 18. get_top_genre_artists:
To return the top artists for the given genre

<b>Examples:</b>
```R
### to get top artist of rock genre
data=get_top_genre_artists(api_key,"rock")
```

### 19. get_genre_info:
To get basic information about a genre.

<b>Examples:</b>

```R
### to get rock genre info
data=get_genre_info(api_key,"rock")
```

### 20. search_genre:
To search for genres by name.

<b>Examples:</b>

```R
### to search rock genres
data=search_genre(api_key,"rock")
```

### 21. search_songs:
To search songs.

<b>Sort options:</b> tempo-asc, duration-asc, loudness-asc, speechiness-asc, acousticness-asc, liveness-asc, 
artist_familiarity-asc, artist_hotttnesss-asc, artist_start_year-asc, artist_start_year-desc, artist_end_year-asc, 
artist_end_year-desc, song_hotttnesss-asc, latitude-asc, longitude-asc, mode-asc, key-asc, tempo-desc, duration-desc, 
loudness-desc, liveness-desc, speechiness-desc, acousticness-desc, artist_familiarity-desc, artist_hotttnesss-desc, 
song_hotttnesss-desc, latitude-desc, longitude-desc, mode-desc, key-desc, energy-asc, energy-desc, danceability-asc, 
danceability-desc

<b>min_name options:</b> min_tempo, min_duration, min_loudness, artist_min_familiarity,  song_min_hotttnesss, a
artist_min_hotttnesss, min_longitude, min_latitude,  min_danceability,  min_energy, min_liveness, min_speechiness, 
min_acousticness

<b>max_name options:</b> max_tempo, max_duration, max_loudness, artist_max_familiarity,  song_max_hotttnesss, 
artist_max_hotttnesss, max_longitude, max_latitude,  max_danceability,  max_energy, max_liveness, max_speechiness, 
max_acousticness

<b>Examples:</b>

```R
### using artist name
data1=search_songs(api_key,artist="coldplay")

### using artist name and song title
data2=search_songs(api_key,combined ="coldplay paradise")

### using other parameters
data2=search_songs(api_key,style="pop",min_name = c("artist_min_hotttnesss","min_tempo"),min_val = c(0.7,100),start=0,results = 54)
```

### 22. basic_playlist 
To return basic playlist.

<b>limited interactivity:</b> When the limited_interactivity parameter is set to true, the playlist will conform to the following 
<b>rules:</b>
* no more than 2 songs in a row from the same album
* no more than 3 songs from an album in a 3 hour period
* no more than 3 different songs in a row by the same artist
* no more than 4 songs by the same artist in a 3 hour period

If limited_interactivity is set to true, skipped songs are not considered to have been played for limited interactivity 
conformance purposes. If limited_interactivity is set to 'styleb', skipped songs are considered to have been played for 
limited interactivity purposes.

<b>Playlist Types:</b>
* artist-radio - plays songs for the given artists and similar artists
* song-radio - plays songs similar to the song specified.
* genre-radio - plays songs from artists matching the given genre

<b>Examples:</b>

```R
### using artist names
data1=basic_playlist(api_key,artist = c("coldplay","maroon 5"),results = 36)

### using genre and partner catalog
data2=basic_playlist(api_key,genre=c("rock","rap"),results = 36,partner="spotify",type="genre-radio")

### using song ID
data3=basic_playlist(api_key,song_id = "SOYKZCH150A6E23DA1",limited_interactivity = "true",type="song-radio")
```

### 23. standard_static_playlist:
To return standard static playlist.

Song Type When generating a playlist, the song_type parameter can be used to restrict the playlist to songs that have a 
matching song_type state. Currently supported song types are:

* christmas - songs that are appropriate to play during the Christmas holiday season
* live - songs that were performed in front of an audience
* studio - songs that were recorded in a studio
* acoustic - songs that created mostly with acoustic technology. This is a beta feature.
* electric - songs that created mostly with electric technology. This is a beta feature.

The song_type state can be one of the following values:

* true - only return songs tagged as given type. If no state is given, 'true' is assumed.
* false - only return songs not tagged as given type
* seed - only return songs that match the song_type of the seed(s)
* any - any songs can be returned, whether they match the type or not.

The syntax for setting a song type is as follows:

* song_type=christmas - sets christmas song type to true
* song_type=christmas:true - sets christmas song type to true
* song_type=christmas:false - sets christmas song type to false
* song_type=christmas:seed - sets christmas song type to match the seed
* song_type=christmas:any - sets christmas song type to any

<b>Boosting:</b> This method can take multiple seed artists or songs. You an give a seed more weight by boosting the item. 
A boost is an affinity for an argument that gives it more or less weight when making calculations based on the argument. In
case arguments are not meant to be equally valued, the boost can help clarify where along a spectrum each argument falls. 
The boost is a floating point value, where 1 gives the normal weight. It is signified by appending a caret and weight to 
the argument. Prepending a seed with a '-' indicates that the item should be skipped.

<b>Examples:</b>

```R
### using boosting and artist name
data1=standard_static_playlist(api_key,artist=c("adele","eminem^2"),results=50)

### using genre and song type
data2=standard_static_playlist(api_key,genre=c("pop","blues"),song_type="live",results=50,type="genre-radio")

### using genre, song type and adventurousness factor
data3=standard_static_playlist(api_key,genre=c("pop","blues"),song_type="live",results=50,type="genre-radio",adventurousness = 0.8)
```

### 24. similar_genres
To return similar genres to a given genre.

<b>Examples:</b>

```R
### to give similar genres
data1=similar_genres(api_key,"rock")
```

### Resources
* [EchoNest API Documentation](http://developer.echonest.com/docs/v4)
