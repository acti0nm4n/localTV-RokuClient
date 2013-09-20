Function Main() as void

    screen = CreateObject("roListScreen")
    port = CreateObject("roMessagePort")
    screen.SetMessagePort(port)
    player = CreateObject("roVideoPlayer")
    canvas = CreateObject("roImageCanvas")

    contentList = LoadFeed()
    
    InitTheme()
    
    'screen.SetHeader("localTV")
    'screen.SetBreadcrumbText("Video", "Breakfast")
    screen.SetContent(contentList)
    screen.show()
    while (true)
        msg = wait(0, port)
        if (type(msg) = "roListScreenEvent")

            if (msg.isListItemSelected())
                
                rect = canvas.GetCanvasRect()
                                 
                canvas.SetMessagePort(port)
                canvas.SetLayer(0, { color: "#00000000", CompositionMode: "Source" })
                canvas.Show()  
        
                
                player.SetMessagePort(port)
                player.SetLoop(true)
                player.SetPositionNotificationPeriod(1)
                player.SetDestinationRect(rect)
                
                now = contentList.GetEntry(msg.GetIndex())
                
                nowPath = "http://192.168.1.7" + now.shortdescriptionline2
                
                print ("playing:"+nowPath)
                
                contentListCurrent = []
                contentListCurrent.push({
                        Stream: { url: nowPath }
                        StreamFormat: "mp4"
                })
                
                player.SetContentList(contentListCurrent)
                player.Play()

            endif      
        endif
    end while
End Function

Function InitTheme() as void
    app = CreateObject("roAppManager")
    
    listItemHighlight           = "#FFFFFF"
    listItemText                = "#707070"
    brandingGreen               = "#37491D"
    backgroundColor             = "#e0e0e0"
    theme = {
        BackgroundColor: backgroundColor
        OverhangSliceHD: "pkg:/images/Overhang_Slice_HD.png"
        OverhangSliceSD: "pkg:/images/Overhang_Slice_HD.png"
        OverhangLogoHD: "pkg:/images/channel_diner_logo.png"
        OverhangLogoSD: "pkg:/images/channel_diner_logo.png"
        OverhangOffsetSD_X: "25"
        OverhangOffsetSD_Y: "15"
        OverhangOffsetHD_X: "25"
        OverhangOffsetHD_Y: "15"
        BreadcrumbTextLeft: brandingGreen
        BreadcrumbTextRight: "#E1DFE0"
        BreadcrumbDelimiter: brandingGreen
        
        ListItemText: listItemText
        ListItemHighlightText: listItemHighlight
        ListScreenDescriptionText: listItemText
        ListItemHighlightHD: "pkg:/images/select_bkgnd.png"
        ListItemHighlightSD: "pkg:/images/select_bkgnd.png"
        CounterTextLeft: brandingGreen
        CounterSeparator: brandingGreen
        GridScreenBackgroundColor: backgroundColor
        GridScreenListNameColor: brandingGreen
        GridScreenDescriptionTitleColor: brandingGreen
        GridScreenLogoHD: "pkg://images/channel_diner_logo.png"
        GridScreenLogoSD: "pkg://images/channel_diner_logo.png"
        GridScreenOverhangHeightHD: "138"
        GridScreenOverhangHeightSD: "138"
        GridScreenOverhangSliceHD: "pkg:/images/Overhang_Slice_HD.png"
        GridScreenOverhangSliceSD: "pkg:/images/Overhang_Slice_HD.png"
        GridScreenLogoOffsetHD_X: "25"
        GridScreenLogoOffsetHD_Y: "15"
        GridScreenLogoOffsetSD_X: "25"
        GridScreenLogoOffsetSD_Y: "15"
    }
    'app.SetTheme( theme )
End Function

Function LoadFeed() as object
    
    request = CreateObject("roUrlTransfer")
    request.SetUrl("http://192.168.1.7/localTV/")
    html = request.GetToString()
    
    feedData = ParseJSON(html)

    tmp = []

    for each video in feedData.Videos
        tmp.Push({
            Title: video.name,
            ShortDescriptionLine1: video.name,
            ShortDescriptionLine2: video.path 
        })
    end for
        
    return tmp
    
End Function