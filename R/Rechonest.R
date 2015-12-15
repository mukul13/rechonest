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
#' @return data frame giving artist's data
#' @export
#' @examples
#' data=search_artist_by_name(api_key,"coldplay",sort="hotttnesss-desc",results=50)

search_artist_by_name=function(api_key,name=NA,style=NA,hotttnesss=T,description=NA,
                               results=NA,sort=NA,partner=NA)
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

#' To search artist by using Echo Nest ID
#'
#' @param api_key Echo Nest API key
#' @param id Echo Nest ID
#' @return data frame giving artist's data
#' @export
#' @examples
#' data=search_artist_by_id(api_key,id="ARJ7KF01187B98D717" )

search_artist_by_id=function(api_key,id)
{
  url=paste("http://developer.echonest.com/api/v4/artist/hotttnesss?api_key=",api_key,"&id=",id,sep="")
  rd=getURL(url)
  rd=fromJSON(rd)

  data=rd$response$artist
  data
}

#' To search similar artists by using names
#'
#' @param api_key Echo Nest API key
#' @param name artists' name (maximum upto 5 names)
#' @param hotttnesss artist's hotttnesss
#' @param results maximum size
#' @return data frame giving similar artists' data
#' @export
#' @examples
#' data=similar_artists_by_names(api_key,name=c("coldplay","adele","maroon 5"),results=35 )

similar_artists_by_names=function(api_key,name=NA,hotttnesss=T,results=NA)
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

  if(hotttnesss)
  {
    url=paste(url,"&bucket=hotttnesss",sep="")
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


#' To search similar artists by using ids
#'
#' @param api_key Echo Nest API key
#' @param id artists' id (maximum upto 5 ids)
#' @param hotttnesss artist's hotttnesss
#' @param results maximum size
#' @return data frame giving similar artists' data
#' @export
#' @examples
#' data=similar_artists_by_ids(api_key,id=c("ARJ7KF01187B98D717","AR7J9AP1187FB5BD64","ARF5M7Q1187FB501E8"),results=35 )

similar_artists_by_ids=function(api_key,id=NA,hotttnesss=T,results=NA)
{
  url=paste("http://developer.echonest.com/api/v4/artist/similar?api_key=",api_key,"&format=json",sep="")
  final=""

  if(!is.na(id))
  {
    len=length(id)
    for(i in 1:len)
    {
      id[i]=gsub(" ","+",id[i])
      url=paste(url,"&id=",id[i],sep="")

    }
  }

  if(hotttnesss)
  {
    url=paste(url,"&bucket=hotttnesss",sep="")
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
#' @param blogs blogs about artis
#' @param news news articles about artist
#' @param reviews reviews about artist
#' @param familiarity artist's familiarity
#' @param audio artist's audio details
#' @param images artist's images details
#' @param songs artist's songs details
#' @param results maximum size
#' @return data frame giving artist's hotttnesss
#' @export
#' @examples
#' data=get_artist_data(api_key,name="coldplay",terms=T,blogs=T)

get_artist_data=function(api_key,name=NA,id=NA,hotttnesss=T,terms=F,blogs=F,news=F,familiarity=F,audio=F,images=F,songs=F,reviews=F)
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
    url=paste(url,"&bucket=hotttnesss",sep="")
  }

  if(familiarity)
  {
    url=paste(url,"&bucket=familiarity",sep="")
  }

  if(blogs)
  {
    url=paste(url,"&bucket=blogs",sep="")
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
#' @return data frame giving news about artist
#' @export
#' @examples
#' data=get_artist_news(api_key,name="coldplay",results=135)

get_artist_news=function(api_key,name=NA,id=NA,results=NA)
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
#' @return data frame giving blogs about artist
#' @export
#' @examples
#' data=get_artist_blogs(api_key,name="coldplay",results=135)

get_artist_blogs=function(api_key,name=NA,id=NA,results=NA)
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

  url=paste(url,"&bucket=terms",sep="")
  rd=getURL(url)
  rd=fromJSON(rd)

  data=rd$response$artist
  data
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

get_artist_songs=function(api_key,name=NA,id=NA)
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

  url=paste(url,"&bucket=songs",sep="")
  rd=getURL(url)
  rd=fromJSON(rd)
  data=rd$response$artist
  data
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
#' @param results maximum size
#' @return data frame giving artist's familiarity
#' @export
#' @examples
#' data=search_songs(api_key,style="pop",results=131)

search_songs=function(api_key,name=NA,id=NA,hotttnesss=T,style=NA,
                      title=NA,sort=NA,audio_summary=F,partner=NA,min_name=NA,
                      max_name=NA,min_val=NA,max_val=NA,results=NA)
{
  url=paste("http://developer.echonest.com/api/v4/song/search?api_key=",api_key,"&format=json",sep="")
  final=""
  if(!is.na(name))
  {
    name=gsub(" ","+",name)
    url=paste(url,"&artist=",name,sep="")
  }
  if(!is.na(id))
  {
    url=paste(url,"&artist_id=",id,sep="")
  }

  if(hotttnesss)
  {
    url=paste(url,"&bucket=song_hotttnesss",sep="")
  }

  if(audio_summary)
  {
    url=paste(url,"&bucket=audio_summary",sep="")
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
      url=paste(url,"&min_",min_name[i],"=",min_val[i],sep="")
    }
  }

  if(!is.na(max_name))
  {
    len=length(max_name)
    for(i in 1:len)
    {
      url=paste(url,"&max_",max_name[i],"=",max_val[i],sep="")
    }
  }

  if(!is.na(title))
  {
    title=gsub(" ","+",title)
    url=paste(url,"&title=",title,sep="")
  }

  if(is.na(results))
  {
    rd=getURL(url)
    rd=fromJSON(rd)

    data=rd$response$songs
    final=data

  }
  if(!is.na(results))
  {
    count=0
    if(results<=100)
    {
      url1=paste(url,"&start=0",sep="")
      url1=paste(url1,"&results=",results,sep="")
      rd=getURL(url1)
      rd=fromJSON(rd)

      data=rd$response$songs
      final=data

    }
    data=""
    if(results>100 && results>=count)
    {
      while(results>count)
      {
        
        url1=paste(url,"&start=",count,sep="")

        if(count+100<results)
          url1=paste(url1,"&results=",100,sep="")
        if(count+100>=results)
          url1=paste(url1,"&results=",results%%100,sep="")
       
        rd=getURL(url1)
        rd=fromJSON(rd)

        if(count==0)
        {
          data=rd$response$songs
        }
        else
          {
            data=rbind(data,rd$response$songs)
          }
        final=data
        count=count+100
        
      }
    }

  }
  # rd=getURL(url)
  #  rd=fromJSON(rd)

  # data=rd$response$songs
  #data
  final
}

