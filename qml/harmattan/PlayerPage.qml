﻿import QtQuick 1.1
import com.nokia.meego 1.1
import QtMultimediaKit 1.1
import com.yeatse.cloudmusic 1.0
import "../js/util.js" as Util
import "../js/api.js" as Api
import "./UIConstants.js" as UI

Page {
    id: page

    property string callerType: ""
    property variant callerParam: null

    property int currentIndex: -1
    property MusicInfo currentMusic: null
    property url coverImageUrl: ""

    property string callerTypePrivateFM: "PrivateFM"
    property string callerTypeDJ: "DJ"
    property string callerTypeDownload: "DownloadPage"
    property string callerTypeSingle: "SingleMusic"

    property string playModeNormal: "Normal"
    property string playModeSingleMusic: "Single"
    property string playModeShuffle: "Shuffle"

    property bool isMusicCollected: false
    property bool isMusicCollecting: false
    property bool isMusicDownloaded: false

    property string playMode: qmlApi.getPlayMode()
    onPlayModeChanged: qmlApi.savePlayMode(playMode)

    function playPrivateFM() {
        bringToFront()
        if (callerType != callerTypePrivateFM || !audio.playing) {
            callerType = callerTypePrivateFM
            callerParam = null

            musicFetcher.reset()
            musicFetcher.disconnect()
            musicFetcher.loadPrivateFM()
            musicFetcher.loadingChanged.connect(musicFetcher.firstListLoaded)
        }
        else if (audio.paused) {
            audio.play()
        }
    }

    function playFetcher(type, param, fetcher, index) {
        if (index != -1 && type == callerType && qmlApi.compareVariant(param, callerParam)
                && audio.playing && currentMusic.musicId == fetcher.dataAt(index).musicId)
        {
            if (audio.paused) audio.play()
            else bringToFront()
            return
        }

        callerType = type
        callerParam = param

        musicFetcher.disconnect()
        musicFetcher.loadFromFetcher(fetcher)

        if (index == -1) {
            if (playMode == playModeShuffle)
                index = Math.floor(Math.random() * musicFetcher.count)
            else
                index = 0
        }

        if (audio.status == Audio.Loading)
            audio.waitingIndex = index
        else
            audio.setCurrentMusic(index)
    }

    function playDJ(djId) {
        if (callerType != callerTypeDJ || !qmlApi.compareVariant(callerParam, djId) || !audio.playing) {
            callerType = callerTypeDJ
            callerParam = djId

            musicFetcher.reset()
            musicFetcher.disconnect()
            musicFetcher.loadDJDetail(djId)
            musicFetcher.loadingChanged.connect(musicFetcher.firstListLoaded)
        }
        else if (audio.paused) {
            audio.play()
        }
        else {
            bringToFront()
        }
    }

    function playDownloader(model, id) {
        if (model.count == 0) return

        callerType = callerTypeDownload
        callerParam = null

        musicFetcher.disconnect()
        musicFetcher.loadFromDownloadModel(model)

        var index = id == "" && playMode == playModeShuffle
                ? Math.floor(Math.random() * musicFetcher.count)
                : Math.max(0, musicFetcher.getIndexByMusicId(id))

        if (audio.status == Audio.Loading)
            audio.waitingIndex = index
        else
            audio.setCurrentMusic(index)
    }

    function playSingleMusic(musicInfo) {
        callerType = callerTypeSingle
        callerParam = null

        musicFetcher.disconnect()
        musicFetcher.loadFromMusicInfo(musicInfo)

				//k console.log(JSON.stringify(musicInfo));

        if (audio.status == Audio.Loading)
            audio.waitingIndex = 0
        else
            audio.setCurrentMusic(0)
    }

    function bringToFront() {
        if (app.pageStack.currentPage != page) {
            if (app.pageStack.find(function(p){ return p == page }))
                app.pageStack.pop(page)
            else
                app.pageStack.push(page)
        }
    }

    function collectCurrentRadio(like) {
        if (callerType != callerTypePrivateFM || currentMusic == null)
            return

        var opt = { id: currentMusic.musicId, like: like, sec: Math.floor(audio.position / 1000) }
        var s = function() {
            isMusicCollected = like
            collector.loadList()
            isMusicCollecting = false
        }
        var f = function(err) {
            isMusicCollecting = false
            console.log("like radio err", err)
        }
        isMusicCollecting = true
        Api.collectRadioMusic(opt, s, f)
    }

    function addCurrentRadioToTrash() {
        if (callerType != callerTypePrivateFM || currentMusic == null)
            return

        var opt = { id: currentMusic.musicId, sec: Math.floor(audio.position / 1000) }
        Api.addRadioMusicToTrash(opt, collector.loadList, new Function())
    }

    orientationLock: PageOrientation.LockPortrait

    tools: ToolBarLayout {
        ToolIcon {
            platformIconId: "toolbar-back"
            onClicked: pageStack.pop()
        }
        ToolIcon {
            visible: callerType != ""
                     && callerType != callerTypeDJ
                     && callerType != callerTypePrivateFM
                     && callerType != callerTypeSingle
            platformIconId: playMode == playModeShuffle ? "toolbar-shuffle" : "toolbar-repeat"
            Label {
                anchors {
                    bottom: parent.bottom; horizontalCenter: parent.horizontalCenter
                    bottomMargin: 10; horizontalCenterOffset: 5
                }
                platformStyle: LabelStyle {
                    fontPixelSize: UI.FONT_XXSMALL
                }
                visible: playMode == playModeSingleMusic
                text: "1"
            }
            onClicked: {
                if (playMode == playModeShuffle)
                    playMode = playModeSingleMusic
                else if (playMode == playModeSingleMusic)
                    playMode = playModeNormal
                else
                    playMode = playModeShuffle
            }
        }
        ToolIcon {
            platformIconId: "toolbar-view-menu"
            onClicked: menu.open()
        }
    }

    Connections {
        target: collector
        onDataChanged: {
            isMusicCollected = currentMusic != null && collector.isCollected(currentMusic.musicId)
        }
    }

    MusicFetcher {
        id: musicFetcher

        function disconnect() {
            loadingChanged.disconnect(firstListLoaded)
            loadingChanged.disconnect(privateFMListAppended)
        }

        function firstListLoaded() {
            if (loading) return
            disconnect()
            if (count > 0) {
                if (audio.status == Audio.Loading)
                    audio.waitingIndex = 0
                else
                    audio.setCurrentMusic(0)
            }
        }

        function privateFMListAppended() {
            if (loading) return
            disconnect()
            if (callerType == callerTypePrivateFM && currentIndex < count - 1) {
                if (audio.status == Audio.Loading)
                    audio.waitingIndex = currentIndex + 1
                else
                    audio.setCurrentMusic(currentIndex + 1)
            }
        }
    }

    Audio {
        id: audio

        property int waitingIndex: -1
        property int retryCount: 0

        function setCurrentMusic(index) {
            waitingIndex = -1
            retryCount = 0
            if (index >= 0 && index < musicFetcher.count) {
                currentMusic = musicFetcher.dataAt(index)
                coverImageUrl = Api.getScaledImageUrl(currentMusic.albumImageUrl, 640)
                currentIndex = index

                var loc = downloader.getCompletedFile(currentMusic.musicId)
                if (qmlApi.isFileExists(loc))
                    audio.source = "file:///" + loc
                else
                    audio.source = currentMusic.getUrl(MusicInfo.LowQuality)
										//k console.log(audio.source);

                audio.position = 0
                audio.play()

                isMusicCollecting = false
                if (callerType == callerTypePrivateFM)
                    isMusicCollected = currentMusic.starred
                else
                    isMusicCollected = collector.isCollected(currentMusic.musicId)

                isMusicDownloaded = downloader.containsRecord(currentMusic.musicId)

                if (coverFlip.lrcVisible)
                    lyricItem.loadLyric(currentMusic.musicId)

                if (app.pageStack.currentPage != page || !Qt.application.active) {
                    infoBanner.showMessage("正在播放: %1 - %2".arg(currentMusic.artistsDisplayName).arg(currentMusic.musicName))
//                    qmlApi.showNotification("网易云音乐",
//                                            "正在播放: %1 - %2".arg(currentMusic.artistsDisplayName).arg(currentMusic.musicName),
//                                            1)
                }

                progressArea.enabled = seekable;

            }
        }

        function playNextMusic() {
            if (callerType == callerTypePrivateFM) {
                if (currentIndex >= musicFetcher.count - 2 && !musicFetcher.loading)
                    musicFetcher.loadPrivateFM()

                if (currentIndex < musicFetcher.count - 1)
                    setCurrentMusic(currentIndex + 1)
                else {
                    musicFetcher.disconnect()
                    musicFetcher.loadingChanged.connect(musicFetcher.privateFMListAppended)
                }
            }
            else if (musicFetcher.count == 0) {
                playPrivateFM()
            }
            else if (callerType == callerTypeDJ || callerType == callerTypeSingle || musicFetcher.count == 1) {
                setCurrentMusic(0)
            }
            else if (playMode == playModeShuffle) {
                var index = currentIndex
                while (index == currentIndex)
                    index = Math.floor(Math.random() * musicFetcher.count)
                setCurrentMusic(index)
            }
            else if (playMode == playModeSingleMusic) {
                setCurrentMusic(currentIndex)
            }
            else {
                if (currentIndex < musicFetcher.count - 1)
                    setCurrentMusic(currentIndex + 1)
                else
                    setCurrentMusic(0)
            }
        }

        function handleTimeOut() {
            if (retryCount < 1) {
                var prefix1 = "http://m1.music.126.net", prefix2 = "http://m2.music.126.net"
                var src = audio.source.toString()
                if (src.indexOf(prefix1) == 0 || src.indexOf(prefix2) == 0) {
                    if (src.indexOf(prefix1) == 0)
                        src = src.replace(prefix1, prefix2)
                    else
                        src = src.replace(prefix2, prefix1)

                    retryCount ++
                    audio.source = src
                    audio.position = 0
                    audio.play()
                    return
                }
            }
            audio.playNextMusic()
        }

        function debugStatus() {
            switch (status) {
            case Audio.NoMedia: return "no media"
            case Audio.Loading: return "loading"
            case Audio.Loaded: return "loaded"
            case Audio.Buffering: return "buffering"
            case Audio.Stalled: return "stalled"
            case Audio.Buffered: return "buffered"
            case Audio.EndOfMedia: return "end of media"
            case Audio.InvalidMedia: return "invalid media"
            case Audio.UnknownStatus: return "unknown status"
            default: return ""
            }
        }

        function debugError() {
            switch (error) {
            case Audio.NoError: return "no error"
            case Audio.ResourceError: return "resource error"
            case Audio.FormatError: return "format error"
            case Audio.NetworkError: return "network error"
            case Audio.AccessDenied: return "access denied"
            case Audio.ServiceMissing: return "service missing"
            default: return ""
            }
        }

        onStatusChanged: {
            console.log("audio status changed:", debugStatus(), debugError())
            if (status != Audio.Loading) {
                if (waitingIndex >= 0 && waitingIndex < musicFetcher.count) {
                    setCurrentMusic(waitingIndex)
                    return
                }
            }

            if (status == Audio.Stalled) {
                timeoutListener.restart()
            }
            else {
                timeoutListener.stop()
            }

            if (status == Audio.EndOfMedia) {
                playNextMusic()
            }
        }

        onError: {
            console.log("error occured:", debugError(), errorString, source)
            if (error == Audio.ResourceError)
                audio.handleTimeOut()
            else if (error == Audio.FormatError || error == Audio.AccessDenied)
                playNextMusic()
        }
    }

    Connections {
        target: Qt.application.active
                && page.status == PageStatus.Active
                && coverFlip.lrcVisible ? audio : null

        onPositionChanged: lyricItem.setPosition(audio.position)
    }

    Timer {
        id: timeoutListener
        interval: 5 * 1000
        onTriggered: audio.handleTimeOut()
    }

    Flipable {
        id: coverFlip
        property bool lrcVisible: false
        anchors {
            top: parent.top; topMargin: 48
            horizontalCenter: parent.horizontalCenter
        }
        width: parent.width - anchors.topMargin * 2
        height: width
        front: Image {
            id: coverImage
            anchors.fill: parent
            fillMode: Image.PreserveAspectCrop
            source: coverImageUrl

            Image {
                visible: coverImage.status != Image.Ready
                anchors.fill: coverImage
                sourceSize { width: width; height: height }
                source: "gfx/default_play_cover.png"
            }

            MouseArea {
                anchors.fill: parent
                enabled: currentMusic != null
                onClicked: coverFlip.lrcVisible = true
            }
        }
        back: LyricItem {
            id: lyricItem
            anchors.fill: parent
            onClicked: coverFlip.lrcVisible = false
						//k r1
						onPressAndHold: {
							if(lyricItem.copy_lyric_to_clipboard() > 0)
								infoBanner.showMessage("已复制歌词到粘贴板")
						}
						//k r1
        }
        transform: Rotation {
            id: flipRotation
            origin { x: coverFlip.width / 2; y: coverFlip.height / 2 }
            axis { x: 0; y: 1; z: 0 }
            angle: 0
        }
        states: [
            State {
                name: "back"
                PropertyChanges { target: flipRotation; angle: 180 }
                when: coverFlip.lrcVisible
            }
        ]
        transitions: [
            Transition {
                to: ""
                NumberAnimation { property: "angle" }
            },
            Transition {
                to: "back"
                SequentialAnimation {
                    NumberAnimation { property: "angle" }
                    ScriptAction { script: lyricItem.loadLyric(currentMusic.musicId) }
                }
            }
        ]
    }

    ProgressBar {
        id: progressBar
        anchors {
            left: coverFlip.left; right: coverFlip.right
            top: coverFlip.bottom
        }
        value: audio.position / audio.duration * 1.0
        indeterminate: audio.status == Audio.Loading || audio.status == Audio.Stalled
                       || (!audio.playing && musicFetcher.loading)

        //k r1
        MouseArea{
            id: progressArea
            anchors.centerIn: parent;
            enabled: false;
            width: parent.width;
            height: 3 * parent.height;
            onReleased:{
                if(audio.seekable) {
                    audio.position = audio.duration * mouse.x / parent.width;
                }
            }
        }
        //k r1
    }

    Text {
        id: positionLabel
        anchors {
            left: progressBar.left; top: progressBar.bottom
        }
        font.pixelSize: UI.FONT_SMALL
        color: UI.COLOR_INVERTED_SECONDARY_FOREGROUND
        text: Util.formatTime(audio.position)
    }

    Text {
        anchors {
            right: progressBar.right; top: progressBar.bottom
        }
        font.pixelSize: UI.FONT_SMALL
        color: UI.COLOR_INVERTED_SECONDARY_FOREGROUND
        text: currentMusic ? Util.formatTime(currentMusic.musicDuration) : "00:00"
    }
    Item {
        anchors {
            top: positionLabel.bottom; bottom: controlButton.top
            left: parent.left; right: parent.right
        }
        Column {
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width
            spacing: UI.PADDING_MEDIUM
            Text {
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.Wrap
                elide: Text.ElideRight
                maximumLineCount: 2
                color: UI.COLOR_INVERTED_FOREGROUND
                font.pixelSize: UI.FONT_LARGE
                text: currentMusic ? currentMusic.musicName : ""
            }
            Text {
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.Wrap
                elide: Text.ElideRight
                maximumLineCount: 2
                color: UI.COLOR_INVERTED_SECONDARY_FOREGROUND
                font.pixelSize: UI.FONT_SMALL
                font.weight: Font.Light
                text: currentMusic ? currentMusic.artistsDisplayName : ""
            }
        }
    }

    Row {
        id: controlButton

        anchors { bottom: parent.bottom; horizontalCenter: parent.horizontalCenter }
        spacing: 36

        ControlButton {
            buttonName: collector.loading || isMusicCollecting
                        ? "loved_dis" : isMusicCollected ? "loved" : "love"
            visible: callerType != callerTypeDJ && currentMusic != null
            enabled: !(collector.loading || isMusicCollecting)
            onClicked: {
                if (!user.loggedIn) {
                    pageStack.push(Qt.resolvedUrl("LoginPage.qml"))
                    return
                }

                if (callerType == callerTypePrivateFM)
                    collectCurrentRadio(!isMusicCollected)
                else if (isMusicCollected)
                    collector.removeCollection(currentMusic.musicId)
                else
                    collector.collectMusic(currentMusic.musicId)
            }
        }

        ControlButton {
            buttonName: audio.playing && !audio.paused ? "pause" : "play"
            onClicked: {
                if (audio.playing) {
                    if (audio.paused) audio.play()
                    else audio.pause()
                }
                else if (musicFetcher.count > 0) {
                    var index = Math.min(Math.max(currentIndex, 0), musicFetcher.count - 1)
                    if (audio.status == Audio.Loading)
                        audio.waitingIndex = index
                    else
                        audio.setCurrentMusic(index)
                }
                else {
                    playPrivateFM()
                }
            }
        }

        ControlButton {
            buttonName: "next"
            enabled: audio.status != Audio.Loading
            onClicked: audio.playNextMusic()
        }

        ControlButton {
            visible: callerType == callerTypePrivateFM && currentMusic != null
            buttonName: "del"
            enabled: audio.status != Audio.Loading
            onClicked: {
                addCurrentRadioToTrash()
                audio.playNextMusic()
            }
        }
    }

    Menu {
        id: menu
        MenuLayout {
            MenuItem {
                enabled: currentMusic != null
                text: currentMusic == null || !isMusicDownloaded ? "下载" : "查看下载"
                onClicked: {
                    if (isMusicDownloaded) {
                        var prop = { startId: currentMusic.musicId,
                            defaultTab: downloader.getCompletedFile(currentMusic.musicId)?1:0 }
                        pageStack.push(Qt.resolvedUrl("DownloadPage.qml"), prop)
                    }
                    else {
                        downloader.addTask(currentMusic)
                        isMusicDownloaded = true
                        infoBanner.showMessage("已添加到下载列表")
                        if (coverFlip.lrcVisible)
                            lyricItem.saveCurrentLyric()
                    }
                }
            }
            MenuItem {
                enabled: callerType != ""
                         && callerType != callerTypeDJ
                         && callerType != callerTypePrivateFM
                         && callerType != callerTypeSingle
                text: "播放列表"
                onClicked: pageStack.push(Qt.resolvedUrl(callerType + ".qml"), callerParam)
            }
            MenuItem {
                text: "评论"
                enabled: currentMusic != null
                onClicked: {
                    var rid
                    if (callerType == callerTypeDJ) {
                        rid = musicFetcher.getRawData().program.commentThreadId
                    }
                    else {
                        rid = currentMusic.commentId
                    }
                    pageStack.push(Qt.resolvedUrl("CommentPage.qml"), {commentId: rid})
                }
            }
        }
    }
}
