#' @import httr
#' @import RCurl
#' @import jsonlite
library(httr)
library(RCurl)
library(jsonlite)



#' To search artist by using name
#'
#' @param api_key Echo Nest API key
#' @param name artist's name
#' @param style artist's style
#' @param hotttnesss artist's hotttnesss (Default is true)
#' @param description artist's description
#' @param results maximum size
#' @param sort to sort ascending or descending
#' @param partner partner catalog
#' @param min_familiarity minimum familiarity
#' @param max_familiarity maximum familiarity
#' @param min_hotttnesss minimum hotttnesss
#' @param max_hotttnesss maximum hotttnesss
#' @param artist_start_year_before Matches artists that have an earliest start year before the given value
#' @param artist_start_year_after Matches artists that have an earliest start year after the given value
#' @param artist_end_year_before 	Matches artists that have a latest end year before the given value
#' @param artist_end_year_after	Matches artists that have a latest end year after the given value
#' @param artist_location artist location
#' @param genre genre name
#' @param mood mood like happy or sad
#' @param rank_type For search by description, style or mood indicates whether results should be ranked by query relevance or by artist familiarity
#' @param fuzzy_match if true, a fuzzy search is performed
#' @return data frame giving artist's data
#' @export
#' @examples
#' data=search_artist(api_key,"coldplay",sort="hotttnesss-desc",results=50)

search_artist=function(api_key,name=NA,style=NA,hotttnesss=T,
                               description=NA,results=NA,sort=NA,partner=NA,
                               artist_location=NA,genre=NA,mood=NA,
                               rank_type="relevance",fuzzy_match=F,
                               max_familiarity=NA,min_familiarity=NA,
                               max_hotttnesss=NA,min_hotttnesss=NA,
                               artist_start_year_before=NA,artist_start_year_after=NA,
                               artist_end_year_before=NA,artist_end_year_after=NA)
{

  url=paste("http://developer.echonest.com/api/v4/artist/search?api_key=",api_key,"&format=json",sep="")
  final=""

#################NAME##########################
  if(!is.na(name))
  {
    name=gsub(" ","+",name)
    url=paste(url,"&name=",name,sep="")
  }

#################STYLE####################
  if(!is.na(style))
  {
    style=gsub(" ","+",style)
    url=paste(url,"&style=",style,sep="")
  }

  if(hotttnesss)
  {
    url=paste(url,"&bucket=hotttnesss",sep="")
  }

  if(!is.na(artist_location))
  {
    artist_location=gsub(" ","+",artist_location)
    url=paste(url,"&artist_location=",artist_location,sep="")
  }
  
  if(!is.na(mood))
  {
    mood=gsub(" ","+",mood)
    url=paste(url,"&mood=",mood,sep="")
  }
  
  if(!is.na(genre))
  {
    genre=gsub(" ","+",genre)
    url=paste(url,"&genre=",genre,sep="")
  }
  
url=paste(url,"&rank_type=",rank_type,sep="") 

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

if(fuzzy_match)
{
  url=paste(url,"&fuzzy_match=true",sep="")
}

if(!is.na(artist_start_year_before))
{
  url=paste(url,"&artist_start_year_before=",artist_start_year_before,sep="")
}

if(!is.na(artist_start_year_after))
{
  url=paste(url,"&artist_start_year_after=",artist_start_year_after,sep="")
}

if(!is.na(artist_end_year_before))
{
  url=paste(url,"&artist_end_year_before=",artist_end_year_before,sep="")
}

if(!is.na(artist_end_year_after))
{
  url=paste(url,"&artist_end_year_after=",artist_end_year_after,sep="")
}

###############DESCRIPTION###############
  if(!is.na(description))
  {
    description=gsub(" ","+",description)
    url=paste(url,"&description=",description,sep="")
  }

#####################PARTNER#####################
  if(!is.na(partner))
  {
    partner=gsub(" ","+",partner)
    url=paste(url,"&bucket=id:",partner,"&limit=true",sep="")
  }

#################SORT###############
  if(!is.na(sort))
  {
    url=paste(url,"&sort=",sort,sep="")
  }


##############################RESULTS#########################
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

#' To search similar artists by using names or IDs
#'
#' @param api_key Echo Nest API key
#' @param name artists' name (maximum upto 5 names)
#' @param id Echo Nest IDs (maximum upto 5 IDs)
#' @param hotttnesss artist's hotttnesss
#' @param results maximum size
#' @param min_familiarity minimum familiarity
#' @param max_familiarity maximum familiarity
#' @param min_hotttnesss minimum hotttnesss
#' @param max_hotttnesss maximum hotttnesss
#' @param artist_start_year_before Matches artists that have an earliest start year before the given value
#' @param artist_start_year_after Matches artists that have an earliest start year after the given value
#' @param artist_end_year_before 	Matches artists that have a latest end year before the given value
#' @param artist_end_year_after	Matches artists that have a latest end year after the given value
#' @return data frame giving similar artists' data
#' @export
#' @examples
#' data=similar_artists(api_key,name=c("coldplay","adele","maroon 5"),results=35 )

similar_artists=function(api_key,name=NA,id=NA,seed_catalog=NA,hotttnesss=T,
                         results=NA, max_familiarity=NA,min_familiarity=NA,
                         max_hotttnesss=NA,min_hotttnesss=NA,
                         artist_start_year_before=NA,artist_start_year_after=NA,
                         artist_end_year_before=NA,artist_end_year_after=NA)
{
  url=paste("http://developer.echonest.com/api/v4/artist/similar?api_key=",api_key,"&format=json",sep="")
  final=""

  if(!is.na(name))
  {
    len=length(name)
    for(i in 1:len)
    {
      name[i]=gsub(" ","+",name[i])
      url=paste(url,"&name=",name[i],sep="")

    }
  }

  if(!is.na(id))
  {
    len=length(id)
    for(i in 1:len)
    {
      id[i]=gsub(" ","+",id[i])
      url=paste(url,"&id=",id[i],sep="")
      
    }
  }
  
  if(!is.na(seed_catalog))
  {
    len=length(seed_catalog)
    for(i in 1:len)
    {
      seed_catalog[i]=gsub(" ","+",seed_catalog[i])
      url=paste(url,"&id=",seed_catalog[i],sep="")
      
    }
    url=paste(url,"&limit=true",sep="")
  }
  
  if(hotttnesss)
  {
    url=paste(url,"&bucket=hotttnesss",sep="")
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
  
  if(!is.na(artist_start_year_before))
  {
    url=paste(url,"&artist_start_year_before=",artist_start_year_before,sep="")
  }
  
  if(!is.na(artist_start_year_after))
  {
    url=paste(url,"&artist_start_year_after=",artist_start_year_after,sep="")
  }
  
  if(!is.na(artist_end_year_before))
  {
    url=paste(url,"&artist_end_year_before=",artist_end_year_before,sep="")
  }
  
  if(!is.na(artist_end_year_after))
  {
    url=paste(url,"&artist_end_year_after=",artist_end_year_after,sep="")
  }
  
  if(is.na(results))
  {
    rd=getURL(url)
    rd=fromJSON(rd)

    data=rd$response$artists
    final=data
  }
  else
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
    else
    {
      url1=paste(url,"&start=0",sep="")
      url1=paste(url1,"&results=",100,sep="")
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
        d=rd$response$artists
        data=rbind(data,rd$response$artists)
        final=data
      }
    }

  }
  final
}


#' To get artist's hotttnesss
#'
#' @param api_key Echo Nest API key
#' @param name artist's name
#' @param id artist's id
#' @param results maximum size
#' @return data frame giving artist's hotttnesss
#' @export
#' @examples
#' data=get_artist_hotttnesss(api_key,name="coldplay")

get_artist_hotttnesss=function(api_key,name=NA,id=NA)
{
  url=paste("http://developer.echonest.com/api/v4/artist/hotttnesss?api_key=",api_key,"&format=json",sep="")

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

  data=rd$response$artist
  data
}

#' To get artist's data
#'
#' @param api_key Echo Nest API key
#' @param name artist's name
#' @param id artist's id
#' @param hotttnesss artist's hotttnesss
#' @param terms artist's terms
#' @param blogs blogs about artist
#' @param news news articles about artist
#' @param reviews reviews about artist
#' @param familiarity artist's familiarity
#' @param audio artist's audio details
#' @param images artist's images details
#' @param songs artist's songs details
#' @param discovery artist's discovery details
#' @param partner partner catalog
#' @param biographies artist's biographies
#' @param doc_counts artist's doc_counts
#' @param artist_location artist location
#' @param years_active years active
#' @param urls urls of artist websites
#' @return data frame giving artist's hotttnesss
#' @export
#' @examples
#' data=get_artist_data(api_key,name="coldplay",terms=T,blogs=T)

get_artist_data=function(api_key,name=NA,id=NA,hotttnesss=T,
                         terms=F,blogs=F,news=F,familiarity=F,
                         audio=F,images=F,songs=F,reviews=F,
                         discovery=F,partner=NA,biographies=F,
                         doc_counts=F,artist_location=F,years_active=F,urls=F)
{
    url=paste("http://developer.echonest.com/api/v4/artist/profile?api_key=",api_key,"&format=json",sep="")
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

  if(hotttnesss)
  {
    url=paste(url,"&bucket=hotttnesss&bucket=hotttnesss_rank",sep="")
  }
  
  if(discovery)
  {
    url=paste(url,"&bucket=discovery&bucket=discovery_rank",sep="")
  }

  if(familiarity)
  {
    url=paste(url,"&bucket=familiarity&bucket=familiarity_rank",sep="")
  }

  if(blogs)
  {
    url=paste(url,"&bucket=blogs",sep="")
  }
  
  if(doc_counts)
  {
    url=paste(url,"&bucket=doc_counts",sep="")
  }
  
  if(years_active)
  {
    url=paste(url,"&bucket=years_active",sep="")
  }
  
  if(artist_location)
  {
    url=paste(url,"&bucket=artist_location",sep="")
  }
  
  if(urls)
  {
    url=paste(url,"&bucket=urls",sep="")
  }
  
  
  
  if(biographies)
  {
    url=paste(url,"&bucket=biographies",sep="")
  }

  if(news)
  {
    url=paste(url,"&bucket=news",sep="")
  }

  if(reviews)
  {
    url=paste(url,"&bucket=reviews",sep="")
  }

  if(songs)
  {
    url=paste(url,"&bucket=songs",sep="")
  }

  if(images)
  {
    url=paste(url,"&bucket=images",sep="")
  }

  if(audio)
  {
    url=paste(url,"&bucket=audio",sep="")
  }

  if(terms)
  {
    url=paste(url,"&bucket=terms",sep="")
  }
  
  if(!is.na(partner))
  {
    partner=gsub(" ","+",partner)
    url=paste(url,"&bucket=id:",partner,sep="")
  }

  rd=getURL(url)
  rd=fromJSON(rd)

  data=rd$response$artist

}

#' To get news about artist
#'
#' @param api_key Echo Nest API key
#' @param name artist's name
#' @param id artist's id
#' @param results maximum size
#' @param high_relevance 	if true only items that are highly relevant for this artist will be returned
#' @return data frame giving news about artist
#' @export
#' @examples
#' data=get_artist_news(api_key,name="coldplay",results=135)

get_artist_news=function(api_key,name=NA,id=NA,results=NA,high_relevance=F)
{
  url=paste("http://developer.echonest.com/api/v4/artist/news?api_key=",api_key,"&format=json",sep="")

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
  
  if(!high_relevance)
  {
    url=paste(url,"&high_relevance=false",sep="")
  }
  else
  {
    url=paste(url,"&high_relevance=true",sep="")
  }

  if(is.na(results))
  {
    rd=getURL(url)
    rd=fromJSON(rd)

    total=rd$response$total
    data=rd$response$news
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
      data=rd$response$news
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
      data=rd$response$news
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

        data=rbind(data,rd$response$news)
        final=data
      }

      final$total=total
    }

  }
  final=as.data.frame(final)
  final
}

#' To get blogs about artist
#'
#' @param api_key Echo Nest API key
#' @param name artist's name
#' @param id artist's id
#' @param results maximum size
#' @param high_relevance 	if true only items that are highly relevant for this artist will be returned
#' @return data frame giving blogs about artist
#' @export
#' @examples
#' data=get_artist_blogs(api_key,name="coldplay",results=135)

get_artist_blogs=function(api_key,name=NA,id=NA,results=NA,high_relevance=F)
{
  url=paste("http://developer.echonest.com/api/v4/artist/blogs?api_key=",api_key,"&format=json",sep="")

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

  if(!high_relevance)
  {
    url=paste(url,"&high_relevance=false",sep="")
  }
  else
  {
    url=paste(url,"&high_relevance=true",sep="")
  }
  
  if(is.na(results))
  {
    rd=getURL(url)
    rd=fromJSON(rd)

    total=rd$response$total
    data=rd$response$blogs
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
      data=rd$response$blogs
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
      data=rd$response$blogs
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

        data=rbind(data,rd$response$blogs)
        final=data
      }

      final$total=total
    }

  }
  final=as.data.frame(final)
  final
}

#' To get reviews about artist
#'
#' @param api_key Echo Nest API key
#' @param name artist's name
#' @param id artist's id
#' @param results maximum size
#' @return data frame giving blogs about artist
#' @export
#' @examples
#' data=get_artist_reviews(api_key,name="coldplay",results=35)

get_artist_reviews=function(api_key,name=NA,id=NA,results=NA)
{
  url=paste("http://developer.echonest.com/api/v4/artist/reviews?api_key=",api_key,"&format=json",sep="")
  
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
    data=rd$response$reviews
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
      data=rd$response$reviews
      final=data
      final$total=total
      
    }
    if(results>=count)
    {
      url1=paste(url,"&start=0",sep="")
      url1=paste(url1,"&results=",100,sep="")
      rd=getURL(url1)
      rd=fromJSON(rd)
      
      total=rd$response$total
      data=rd$response$reviews
      data$date_reviewed=NULL
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
        
        data1=rd$response$reviews
        #data=rbind(data,rd$response$reviews)
        final=data
      }
      final$total=total
    }
    
  }
  final=as.data.frame(final)
  final
}

#' To get artist's terms
#'
#' @param api_key Echo Nest API key
#' @param name artist's name
#' @param id artist's id
#' @return data frame giving artist's terms
#' @export
#' @examples
#' data=get_artist_terms(api_key,name="coldplay")

get_artist_terms=function(api_key,name=NA,id=NA)
{
  url=paste("http://developer.echonest.com/api/v4/artist/terms?api_key=",api_key,"&format=json",sep="")

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

  rd$response$terms
  
}


#' To get artist's songs
#'
#' @param api_key Echo Nest API key
#' @param name artist's name
#' @param id artist's id
#' @return data frame giving artist's songs
#' @export
#' @examples
#' data=get_artist_songs(api_key,name="coldplay")

get_artist_songs=function(api_key,name=NA,id=NA,results=NA)
{
  url=paste("http://developer.echonest.com/api/v4/artist/songs?api_key=",api_key,"&format=json",sep="")
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
    data=rd$response$songs
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
      data=rd$response$songs
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
      data=rd$response$songs
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
        
        data=rbind(data,rd$response$songs)
        final=data
      }
      
      final$total=total
    }
    
  }
  final=as.data.frame(final)
  final
  
  final
}


#' To get artist's familiarity
#'
#' @param api_key Echo Nest API key
#' @param name artist's name
#' @param id artist's id
#' @return data frame giving artist's familiarity
#' @export
#' @examples
#' data=get_artist_familiarity(api_key,name="coldplay")

get_artist_familiarity=function(api_key,name=NA,id=NA)
{
  url=paste("http://developer.echonest.com/api/v4/artist/profile?api_key=",api_key,"&format=json",sep="")

  if(!is.na(name))
  {
    name=gsub(" ","+",name)
    url=paste(url,"&name=",name,sep="")
  }
  if(!is.na(id))
  {
    url=paste(url,"&id=",id,sep="")
  }

  url=paste(url,"&bucket=familiarity",sep="")
  rd=getURL(url)
  rd=fromJSON(rd)

  data=rd$response$artist
  data
}

#' To search song
#'
#' @param api_key Echo Nest API key
#' @param name artist's name
#' @param id artist's id
#' @param hotttnesss song's hotttnesss
#' @param style artist's style
#' @param title song's title
#' @param sort to sort ascending or descending
#' @param audio_summary song's audio summary
#' @param partner partner catalog
#' @param min_name features' minimum value settings
#' @param min_val features' minimum value settings
#' @param max_name features' maximum value settings
#' @param max_val features' maximum value settings
#' @param start the desired index of the first result returned
#' @param results maximum size
#' @param mode the mode of songs
#' @param key the key of songs in the playlist
#' @param currency song currency
#' @param description song's description
#' @param rank_type For search by description, style or mood indicates whether results should be ranked by query relevance or by artist familiarity
#' @param mood a mood like happy or sad
#' @param familiarity song's familiarity
#' @param song_type controls the type of songs returned
#' @param artist_start_year_before Matches artists that have an earliest start year before the given value
#' @param artist_start_year_after Matches artists that have an earliest start year after the given value
#' @param artist_end_year_before 	Matches artists that have a latest end year before the given value
#' @param artist_end_year_after	Matches artists that have a latest end year after the given value
#' @return data frame giving artist's familiarity
#' @export
#' @examples
#' data=search_songs(api_key,style="pop",results=131)

search_songs=function(api_key,artist=NA,artist_id=NA,title=NA,hotttnesss=T,style=NA,artist_location=T,
                      combined=NA,sort=NA,audio_summary=F,partner=NA,min_name=NA,discovery=T,
                      max_name=NA,min_val=NA,max_val=NA,start=NA,results=NA,mode=NA,key=NA,currency=T,
                      description=NA,rank_type="relevance",mood=NA,familiarity=T,
                      song_type=NA,artist_start_year_before=NA,artist_start_year_after=NA,
                      artist_end_year_before=NA,artist_end_year_after=NA)
{
  url=paste("http://developer.echonest.com/api/v4/song/search?api_key=",api_key,"&format=json",sep="")
  final=""
  if(!is.na(artist))
  {
    artist=gsub(" ","+",artist)
    url=paste(url,"&artist=",artist,sep="")
  }
  
  if(!is.na(artist_id))
  {
    url=paste(url,"&artist_id=",artist_id,sep="")
  }
  
  if(!is.na(combined))
  {
    combined=gsub(" ","+",combined)
    url=paste(url,"&combined=",combined,sep="")
  }
  
  if(!is.na(description))
  {
    description=gsub(" ","+",description)
    url=paste(url,"&description=",description,sep="")
  }
  
  if(!is.na(song_type))
  {
    song_type=gsub(" ","+",song_type)
    url=paste(url,"&song_type=",song_type,sep="")
  }
  
  if(!is.na(mood))
  {
    mood=gsub(" ","+",mood)
    url=paste(url,"&mood=",mood,sep="")
  }
  
  if(!is.na(mode))
  {
    mode=gsub(" ","+",mode)
    url=paste(url,"&mode=",mode,sep="")
  }
  
  if(!is.na(key))
  {
    key=gsub(" ","+",key)
    url=paste(url,"&key=",key,sep="")
  }
  
  if(hotttnesss)
  {
    url=paste(url,"&bucket=song_hotttnesss&bucket=song_hotttnesss_rank&bucket=artist_hotttnesss&bucket=artist_hotttnesss_rank",sep="")
  }
  
  if(familiarity)
  {
    url=paste(url,"&bucket=artist_familiarity&bucket=artist_familiarity_rank",sep="")  
  }
  
  if(currency)
  {
    url=paste(url,"&bucket=song_currency&bucket=song_currency_rank",sep="")
  }
  
  if(discovery)
  {
    url=paste(url,"&bucket=artist_discovery&bucket=artist_discovery_rank",sep="")
  }
  
  if(audio_summary)
  {
    url=paste(url,"&bucket=audio_summary",sep="")
  }

  if(artist_location)
  {
    url=paste(url,"&bucket=artist_location",sep="")
  }
  
  
  if(!is.na(sort))
  {
    url=paste(url,"&sort=",sort,sep="")
  }

  if(!is.na(partner))
  {
    url=paste(url,"&bucket=id:",partner,"&limit=true",sep="")
  }

  if(!is.na(style))
  {
    url=paste(url,"&style=",style,sep="")
  }

  if(!is.na(min_name))
  {
    len=length(min_name)
    for(i in 1:len)
    {
      url=paste(url,"&",min_name[i],"=",min_val[i],sep="")
    }
  }

  if(!is.na(max_name))
  {
    len=length(max_name)
    for(i in 1:len)
    {
      
      url=paste(url,"&",max_name[i],"=",max_val[i],sep="")
    }
  }

url=paste(url,"&rank_type=",rank_type,sep="")  
  
  if(!is.na(title))
  {
    title=gsub(" ","+",title)
    url=paste(url,"&title=",title,sep="")
  }

if(!is.na(artist_start_year_before))
{
  url=paste(url,"&artist_start_year_before=",artist_start_year_before,sep="")
}

if(!is.na(artist_start_year_after))
{
  url=paste(url,"&artist_start_year_after=",artist_start_year_after,sep="")
}

if(!is.na(artist_end_year_before))
{
  url=paste(url,"&artist_end_year_before=",artist_end_year_before,sep="")
}

if(!is.na(artist_end_year_after))
{
  url=paste(url,"&artist_end_year_after=",artist_end_year_after,sep="")
}
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

rd$response$songs

}