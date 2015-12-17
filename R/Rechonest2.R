library(httr)
library(RCurl)
library(jsonlite)



#' To get artist's images
#'
#' @param api_key Echo Nest API key
#' @param name artist name
#' @param id Echo Nest ID
#' @param start the desired index of the first result returned
#' @param results the number of results desired
#' @param license the desired licenses of the returned images
#' @return data frame giving artist's images
#' @export
#' @examples
#' data=list_genres(api_key)

get_artist_images=function(api_key,name=NA,id=NA,start=NA,results=NA,license="unknown")
{
  url=paste("http://developer.echonest.com/api/v4/artist/images?api_key=",api_key,"&format=json",sep="")
  final=""
  
  #################NAME##########################
  if(!is.na(name))
  {
    name=gsub(" ","+",name)
    url=paste(url,"&name=",name,sep="")
  }
  
  if(!is.na(id))
  {
    url=paste(url,"&id=",id,sep="")
  }
  
  url=paste(url,"&license=",license,sep="")

  if(!is.na(start))
  {
    url=paste(url,"&start=",start,sep="")  
  }
  
  if(!is.na(results))
  {
    url=paste(url,"&results=",results,sep="")  
    
  }

  rd=getURL(url)
  rd=fromJSON(rd)
  
  rd$response$images
}  


#' To get genre's list
#'
#' @param api_key Echo Nest API key
#' @return data frame giving genre's list
#' @export
#' @examples
#' data=list_genres(api_key)

list_genres=function(api_key)
{
  url=paste("http://developer.echonest.com/api/v4/genre/list?api_key=",api_key,"&format=json",sep="")
  rd=getURL(url)
  rd=fromJSON(rd)
 
  url=paste("http://developer.echonest.com/api/v4/genre/list?api_key=",api_key,"&format=json&results=1000&start=1000",sep="")
  rd1=getURL(url)
  rd1=fromJSON(rd1)
  
  data=rbind(rd$response$genres,rd1$response$genres)
  data
}

#' To get a list of the best typed descriptive terms
#'
#' @param api_key Echo Nest API key
#' @return data frame giving best typed descriptive terms
#' @export
#' @examples
#' data=list_terms(api_key)

list_terms=function(api_key,type="style")
{
  url=paste("http://developer.echonest.com/api/v4/artist/list_terms?api_key=",api_key,"&format=json",sep="")
  url=paste(url,"&type=",type,sep="")
  rd=getURL(url)
  rd=fromJSON(rd)
  rd$response$terms
}

#' To get a list of artist biographies
#'
#' @param api_key Echo Nest API key
#' @param name artist name
#' @param id Echo Nest ID
#' @param results the number of results desired
#' @param license the desired licenses of the returned images
#' @return data frame giving artist's biographies
#' @export
#' @examples
#' data=get_artist_biographies(api_key,name="coldplay")

get_artist_biographies=function(api_key,name=NA,id=NA,results=NA,license="unknown")
{
  url=paste("http://developer.echonest.com/api/v4/artist/biographies?api_key=",api_key,"&format=json",sep="")
  
  final=""
  if(!is.na(name))
  {
    name=gsub(" ","+",name)
    url=paste(url,"&name=",name,sep="")
  }
  if(!is.na(id))
  {
    url=paste(url,"&id=",id,sep="")
  }
  
 url=paste(url,"&license=",license,sep="")
  
  if(is.na(results))
  {
    rd=getURL(url)
    rd=fromJSON(rd)
    
    total=rd$response$total
    data=rd$response$biographies
    final=data
    
    final$total=total
    
  }
  if(!is.na(results))
  {
    count=100
    if(results<count)
    {
      url1=paste(url,"&start=0",sep="")
      url1=paste(url1,"&results=",results,sep="")
      rd=getURL(url1)
      rd=fromJSON(rd)
      
      total=rd$response$total
      data=rd$response$biographies
      final=data
      final$total=total
      
    }
    if(results>=count)
    {
      url1=paste(url,"&start=0",sep="")
      url1=paste(url1,"&results=",count,sep="")
      rd=getURL(url1)
      rd=fromJSON(rd)
      
      total=rd$response$total
      data=rd$response$biographies
      while(results>count)
      {
        url1=paste(url,"&start=",count,sep="")
        
        if(count+100<results)
          url1=paste(url1,"&results=",100,sep="")
        if(count+100>=results)
          url1=paste(url1,"&results=",results%%100,sep="")
        count=count+100
        
        rd=getURL(url1)
        rd=fromJSON(rd)
        
        data=rbind(data,rd$response$biographies)
        final=data
      }
      
      final$total=total
    }
    
  }
  final=as.data.frame(final)
  final
}

#' To extract artist names from text.
#'
#' @param api_key Echo Nest API key
#' @param text text that contains artist names
#' @param min_hotttnesss the minimum hotttnesss for returned artists
#' @param max_hotttnesss the maximum hotttnesss for returned artists
#' @param min_familiarity the minimum familiarity for returned artists
#' @param max_familiarity the maximum familiarity for returned artists
#' @param sort specified the sort order of the results
#' @param results the number of results desired
#' @return data frame giving artist's names
#' @export
#' @examples
#' data=extract_artist_names(api_key,text="I like adele and Maroon 5")

extract_artist_names=function(api_key,text,min_hotttnesss=NA,
                              max_hotttnesss=NA,min_familiarity=NA,
                              max_familiarity=NA,sort=NA,results=NA)
{
  text=gsub(" ","+",text)
  url=paste("http://developer.echonest.com/api/v4/artist/extract?api_key=",api_key,"&format=json&text=",text,sep="")
  final=""
  
  if(!is.na(sort))
  {
    url=paste(url,"&sort=",sort,sep="")
  }
  
  if(!is.na(max_familiarity))
  {
    url=paste(url,"&max_familiarity=",max_familiarity,sep="") 
  }
  
  if(!is.na(min_familiarity))
  {
    url=paste(url,"&min_familiarity=",min_familiarity,sep="") 
  }
  
  if(!is.na(max_hotttnesss))
  {
    url=paste(url,"&max_hotttnesss=",max_hotttnesss,sep="") 
  }
  
  if(!is.na(min_hotttnesss))
  {
    url=paste(url,"&min_hotttnesss=",min_hotttnesss,sep="") 
  }
  
  if(is.na(results))
  {
    rd=getURL(url)
    rd=fromJSON(rd)
    
    data=rd$response$artists
    final=data
  }
  if(!is.na(results))
  {
    url=paste(url,"&results=",results,sep="")
    rd=getURL(url)
    rd=fromJSON(rd)
    
    data=rd$response$artists
    final=data 
  }
  
  final
}

#' To suggest artists based upon partial names
#'
#' @param api_key Echo Nest API key
#' @return name a partial artist name
#' @param results the number of results desired (maximum 15)
#' @return data frame giving artist's names 
#' @export
#' @examples
#' data=suggest_artist_names(api_key,"cold")

suggest_artist_names =function(api_key,name,results=NA)
{
  url=paste("http://developer.echonest.com/api/v4/artist/suggest?api_key=",api_key,"&format=json",sep="")
  name=gsub(" ","+",name)
  url=paste(url,"&name=",name,sep="")
  
  if(!is.na(results))
  {
    url=paste(url,"&results=",results,sep="")
  }
  rd=getURL(url)
  rd=fromJSON(rd)
  rd$response$artists

}

#' To return a list of the top hottt artists
#'
#' @param api_key Echo Nest API key
#' @param genre the set of genres of interest
#' @param results the number of results desired
#' @return data frame giving top hottt artists
#' @export
#' @examples
#' data=get_top_hottt(api_key)

get_top_hottt=function(api_key,genre=NA,results=NA)
{
  url=paste("http://developer.echonest.com/api/v4/artist/top_hottt?api_key=",api_key,"&format=json",sep="")
  final=""
  
  if(!is.na(genre))
  {
    genre=gsub(" ","+",genre)
    url=paste(url,"&genre=",genre,sep="")
  }
  
  url=paste(url,"&bucket=hotttnesss",sep="")

  if(is.na(results))
  {
    rd=getURL(url)
    rd=fromJSON(rd)
    
    data=rd$response$artists
    final=data
  }
  if(!is.na(results))
  {
    count=100
    if(results<count)
    {
      url1=paste(url,"&start=0",sep="")
      url1=paste(url1,"&results=",results,sep="")
      rd=getURL(url1)
      rd=fromJSON(rd)
      
      data=rd$response$artists
      final=data
    }
    if(results>=count)
    {
      url1=paste(url,"&start=0",sep="")
      url1=paste(url1,"&results=",count,sep="")
      rd=getURL(url1)
      rd=fromJSON(rd)
      
      data=rd$response$artists
      while(results>count)
      {
        url1=paste(url,"&start=",count,sep="")
        
        if(count+100<results)
          url1=paste(url1,"&results=",100,sep="")
        if(count+100>=results)
          url1=paste(url1,"&results=",results%%100,sep="")
        count=count+100
        
        rd=getURL(url1)
        rd=fromJSON(rd)
        
        data=rbind(data,rd$response$artists)
        final=data
      }
    }
    
  }
  
  final
}

#' To returns a list of the overall top terms
#'
#' @param api_key Echo Nest API key
#' @param results the number of results desired
#' @return data frame giving top terms
#' @export
#' @examples
#' data=get_top_terms(api_key)

get_top_terms=function(api_key,results=NA)
{
  url=paste("http://developer.echonest.com/api/v4/artist/top_terms?api_key=",api_key,"&format=json",sep="")
  
  if(!is.na(results))
  {
    url=paste(url,"&results=",results,sep="")
  }
  
    rd=getURL(url)
    rd=fromJSON(rd)
    
    rd$response$terms
}

#' To get the twitter handle for an artist
#'
#' @param api_key Echo Nest API key
#' @param name artist name
#' @param id Echo Nest ID
#' @return data frame giving twitter handle
#' @export
#' @examples
#' data=get_twitter_handle(api_key,name="coldplay")

get_twitter_handle=function(api_key,name=NA,id=NA)
{
  url=paste("http://developer.echonest.com/api/v4/artist/twitter?api_key=",api_key,"&format=json",sep="")
  
  if(!is.na(name))
  {
    name=gsub(" ","+",name)
    url=paste(url,"&name=",name,sep="")
  }
  
  if(!is.na(id))
  {
    url=paste(url,"&id=",id,sep="")
  }
  
  rd=getURL(url)
  rd=fromJSON(rd)
  rd$response$artist
}

#' To get a list of video documents found on the web related to an artist
#'
#' @param api_key Echo Nest API key
#' @param name artist name
#' @param id Echo Nest ID
#' @param results the number of results desired
#' @return data frame giving artist's videos
#' @export
#' @examples
#' data=get_artist_videos(api_key,name="coldplay")

get_artist_videos=function(api_key,name=NA,id=NA,results=NA)
{
  url=paste("http://developer.echonest.com/api/v4/artist/video?api_key=",api_key,"&format=json",sep="")
  
  final=""
  if(!is.na(name))
  {
    name=gsub(" ","+",name)
    url=paste(url,"&name=",name,sep="")
  }
  if(!is.na(id))
  {
    url=paste(url,"&id=",id,sep="")
  }
  
  if(is.na(results))
  {
    rd=getURL(url)
    rd=fromJSON(rd)
    
    total=rd$response$total
    data=rd$response$video
    final=data
    final$total=total
    
  }
  if(!is.na(results))
  {
    count=100
    if(results<count)
    {
      url1=paste(url,"&start=0",sep="")
      url1=paste(url1,"&results=",results,sep="")
      rd=getURL(url1)
      rd=fromJSON(rd)
      
      total=rd$response$total
      data=rd$response$video
      final=data
      final$total=total
      
    }
    if(results>=count)
    {
      url1=paste(url,"&start=0",sep="")
      url1=paste(url1,"&results=",count,sep="")
      rd=getURL(url1)
      rd=fromJSON(rd)
      
      total=rd$response$total
      data=rd$response$video
      while(results>count)
      {
        url1=paste(url,"&start=",count,sep="")
        
        if(count+100<results)
          url1=paste(url1,"&results=",100,sep="")
        if(count+100>=results)
          url1=paste(url1,"&results=",results%%100,sep="")
        count=count+100
        
        rd=getURL(url1)
        rd=fromJSON(rd)
        
        data=rbind(data,rd$response$video)
        final=data
      }
      
      final$total=total
    }
    
  }
  final=as.data.frame(final)
  final
}

#' To Return the top artists for the given genre
#'
#' @param api_key Echo Nest API key
#' @param genre the genre name
#' @return data frame top artist of the given genre
#' @export
#' @examples
#' data=get_top_genre_artists(api_key,genre="pop")

get_top_genre_artists=function(api_key,genre)
{
  url=paste("http://developer.echonest.com/api/v4/genre/artists?api_key=",api_key,"&format=json",sep="")
  genre=gsub(" ","+",genre)
  
  url=paste(url,"&name=",genre,sep="")
  url=paste(url,"&bucket=hotttnesss",sep="")
 
  rd=getURL(url)
  rd=fromJSON(rd)
  rd$response$artists 
}

#' To get basic information about a genre
#'
#' @param api_key Echo Nest API key
#' @param genre the genre name
#' @param description genre's description
#' @param urls genre's urls
#' @return data frame giving basic info about a genre
#' @export
#' @examples
#' data=get_genre_info(api_key,genre="post rock")

get_genre_info=function(api_key,genre,description=T,urls=T)
{
  url=paste("http://developer.echonest.com/api/v4/genre/profile?api_key=",api_key,"&format=json",sep="")
  genre=gsub(" ","+",genre)
  
  url=paste(url,"&name=",genre,sep="")
  
  if(description)
  {
    url=paste(url,"&bucket=description",sep="")
  }
  if(urls)
  {
    url=paste(url,"&bucket=urls",sep="")
  }
  rd=getURL(url)
  rd=fromJSON(rd)
  rd$response$genres
}

#' To search for genres by name
#'
#' @param api_key Echo Nest API key
#' @param genre the genre name
#' @param description genre's description
#' @param urls genre's urls
#' @param results the number of results desired
#' @return data frame giving searched genres
#' @export
#' @examples
#' data=search_genre(api_key,genre="rock")
 
search_genre=function(api_key,genre=NA,description=T,urls=T,results=NA)
{
  url=paste("http://developer.echonest.com/api/v4/genre/search?api_key=",api_key,"&format=json",sep="")
 
  if(!is.na(genre))
  {
  genre=gsub(" ","+",genre)
  url=paste(url,"&name=",genre,sep="")
  }
  if(description)
  {
    url=paste(url,"&bucket=description",sep="")
  }
  if(urls)
  {
    url=paste(url,"&bucket=urls",sep="")
  }
  
  if(!is.na(results))
  {
    url=paste(url,"&results=",results,sep="")
  }
  rd=getURL(url)
  rd=fromJSON(rd)
  rd$response$genres
}

#' To return similar genres to a given genre
#'
#' @param api_key Echo Nest API key
#' @param genre the genre name
#' @param description genre's description
#' @param urls genre's urls
#' @param results the number of results desired
#' @return data frame giving similar genres
#' @export
#' @examples
#' data=similar_genres(api_key,genre="rock")

similar_genres=function(api_key,genre=NA,description=T,urls=T,results=NA)
{
  url=paste("http://developer.echonest.com/api/v4/genre/similar?api_key=",api_key,"&format=json",sep="")
  
  if(!is.na(genre))
  {
    genre=gsub(" ","+",genre)
    url=paste(url,"&name=",genre,sep="")
  }
  if(description)
  {
    url=paste(url,"&bucket=description",sep="")
  }
  if(urls)
  {
    url=paste(url,"&bucket=urls",sep="")
  }
  
  if(!is.na(results))
  {
    url=paste(url,"&results=",results,sep="")
  }
  rd=getURL(url)
  rd=fromJSON(rd)
  rd$response$genres
}

#' To return basic playlist
#'
#' @param api_key Echo Nest API key
#' @param type the type of the playlist to be generated
#' @param artist_id artist id 
#' @param artist artist name
#' @param song_id song ID
#' @param genre genre name
#' @param track_id track ID
#' @param results the number of results desired
#' @param partner partner catalog
#' @param tracks tracks info
#' @param limited_interactivity interactivity limitation
#' @return data frame giving basic playlist
#' @export
#' @examples
#' data=basic_playlist(api_key,type="artist-radio",artist=c("coldplay","adele"))

basic_playlist=function(api_key,type=NA,artist_id=NA,artist=NA,song_id=NA,
                        genre=NA,track_id=NA,results=NA,partner=NA,tracks=F,limited_interactivity=NA)
{
  url=paste("http://developer.echonest.com/api/v4/playlist/basic?api_key=",api_key,"&format=json",sep="")

  if(!is.na(type))
  {
    type=gsub(" ","+",type)
    url=paste(url,"&type=",type,sep="")
  }
  
  if(!is.na(artist_id))
  {
    len=length(artist_id)
    for(i in 1:len)
    {
      artist_id[i]=gsub(" ","+",artist_id[i])
      url=paste(url,"&artist_id=",artist_id[i],sep="")
      
    }
  }
  
  if(!is.na(artist))
  {
    len=length(artist)
    for(i in 1:len)
    {
      artist[i]=gsub(" ","+",artist[i])
      url=paste(url,"&artist=",artist[i],sep="")
      
    }
  }
  
  if(!is.na(song_id))
  {
    len=length(song_id)
    for(i in 1:len)
    {
      song_id[i]=gsub(" ","+",song_id[i])
      url=paste(url,"&song_id=",song_id[i],sep="")
      
    }
  }
  
  if(!is.na(genre))
  {
    len=length(genre)
    for(i in 1:len)
    {
      genre[i]=gsub(" ","+",genre[i])
      url=paste(url,"&genre=",genre[i],sep="")
      
    }
  }
  
  if(!is.na(track_id))
  {
    len=length(track_id)
    for(i in 1:len)
    {
      track_id[i]=gsub(" ","+",track_id[i])
      url=paste(url,"&track_id=",track_id[i],sep="")
      
    }
  }
  
  if(tracks)
  {
    url=paste(url,"&bucket=tracks",sep="")
  }
  
  if(!is.na(results))
  {
    url=paste(url,"&results=",results,sep="")
  }
  
  if(!is.na(limited_interactivity))
  {
    url=paste(url,"&limited_interactivity=",limited_interactivity,sep="")
  }
  
  if(!is.na(partner))
  {
    url=paste(url,"&bucket=id:",partner,"&limit=true",sep="")  
  }
  rd=getURL(url)
  rd=fromJSON(rd)
  rd$response$songs
}

#' To return standard static playlist
#'
#' @param api_key Echo Nest API key
#' @param type the type of the playlist to be generated
#' @param artist_id artist id 
#' @param artist artist name
#' @param song_id song ID
#' @param genre genre name
#' @param track_id track ID
#' @param results the number of results desired
#' @param partner partner catalog
#' @param tracks tracks info
#' @param limited_interactivity interactivity limitation
#' @param song_selection to determine how songs are selected from each artist in artist-type playlists
#' @param variety the maximum variety of artists to be represented in the playlist
#' @param distribution controls the distribution of artists in the playlist
#' @param adventurousness controls the trade between known music and unknown music
#' @param seed_catalog ID of seed catalog for the playlist
#' @param song_type controls the type of songs returned
#' @return data frame giving standard static playlist
#' @export
#' @examples
#' data= standard_static_playlist(api_key,type="artist-radio",artist=c("coldplay","adele"))


standard_static_playlist=function(api_key,type=NA,artist_id=NA,artist=NA,song_id=NA,
                        genre=NA,track_id=NA,results=NA,partner=NA,tracks=F,
                        limited_interactivity=NA,song_selection=NA,variety=NA,
                        distribution=NA,adventurousness=NA,seed_catalog=NA,sort=NA,
                        song_type=NA)
{
  url=paste("http://developer.echonest.com/api/v4/playlist/static?api_key=",api_key,"&format=json",sep="")
  
  if(!is.na(type))
  {
    type=gsub(" ","+",type)
    url=paste(url,"&type=",type,sep="")
  }
  
  if(!is.na(artist_id))
  {
    len=length(artist_id)
    for(i in 1:len)
    {
      artist_id[i]=gsub(" ","+",artist_id[i])
      url=paste(url,"&artist_id=",artist_id[i],sep="")
      
    }
  }
  
  if(!is.na(artist))
  {
    len=length(artist)
    for(i in 1:len)
    {
      artist[i]=gsub(" ","+",artist[i])
      url=paste(url,"&artist=",artist[i],sep="")
      
    }
  }
  
  if(!is.na(song_id))
  {
    len=length(song_id)
    for(i in 1:len)
    {
      song_id[i]=gsub(" ","+",song_id[i])
      url=paste(url,"&song_id=",song_id[i],sep="")
      
    }
  }
  
  if(!is.na(genre))
  {
    len=length(genre)
    for(i in 1:len)
    {
      genre[i]=gsub(" ","+",genre[i])
      url=paste(url,"&genre=",genre[i],sep="")
      
    }
  }
  
  if(!is.na(track_id))
  {
    len=length(track_id)
    for(i in 1:len)
    {
      track_id[i]=gsub(" ","+",track_id[i])
      url=paste(url,"&track_id=",track_id[i],sep="")
      
    }
  }
  
  if(tracks)
  {
    url=paste(url,"&bucket=tracks",sep="")
  }
  
  if(!is.na(results))
  {
    url=paste(url,"&results=",results,sep="")
  }
  
  if(!is.na(limited_interactivity))
  {
    url=paste(url,"&limited_interactivity=",limited_interactivity,sep="")
  }
  
  if(!is.na(partner))
  {
    url=paste(url,"&bucket=id:",partner,"&limit=true",sep="")  
  }
  
  if(!is.na(song_type))
  {
    url=paste(url,"&song_type=",song_type,sep="")
  }
  
  if(!is.na(song_selection))
  {
    url=paste(url,"&song_selection=",song_selection,sep="")
  }
  
  if(!is.na(variety))
  {
    url=paste(url,"&variety=",variety,sep="")
  }
  
  if(!is.na(adventurousness))
  {
    url=paste(url,"&adventurousness=",adventurousness,sep="")
  }
  
  if(!is.na(seed_catalog))
  {
    url=paste(url,"&seed_catalog=",seed_catalog,sep="")
  }
  
  if(!is.na(distribution))
  {
    url=paste(url,"&distribution=",distribution,sep="")
  }
  
  
  rd=getURL(url)
  rd=fromJSON(rd)
  rd$response$songs
}
