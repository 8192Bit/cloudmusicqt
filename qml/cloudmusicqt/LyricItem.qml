﻿import QtQuick 1.1
import com.nokia.symbian 1.1
import com.yeatse.cloudmusic 1.0

import "../js/util.js" as Util

Item {
    id: root

    signal clicked

		//k r1
		signal pressAndHold;

		function copy_lyric_to_clipboard()
		{
			var LN = "\n";
			if(!view.model)
				return -1;
			if(view.model.length === 0)
				return 0;

				var r = view.model.join(LN);
				if(r.length !== 0)
					qmlApi.CopyToClipboard(r);
				return r.length;
		}
		//k r1

    property string mid
    property int lineNumber: -1

    function loadLyric(musicId) {
        if (mid != musicId) {
            mid = musicId
            lineNumber = -1
            var file = getLrcFileName(mid)
            if (file == "" || !loader.loadFromFile(file))
                loader.loadFromMusicId(mid)
        }
    }

    function saveCurrentLyric() {
        var file = getLrcFileName(mid)
        if (file != "")
            loader.saveToFile(file)
    }

    function getLrcFileName(id) {
        return Util.getLyricFromMusic(downloader.getDownloadFileName(id))
    }

    function setPosition(millisec) {
        lineNumber = loader.getLineByPosition(millisec, lineNumber)
    }

    LyricLoader {
        id: loader
        onLyricChanged: {
            if (loader.dataAvailable()) {
                lineNumber = hasTimer ? 0 : -1
                var file = getLrcFileName(mid)
                if (file) saveToFile(file)
            }
        }
    }

    ListView {
        id: view
        anchors.fill: parent
        clip: true
        model: loader.lyric
        spacing: platformStyle.paddingLarge
        preferredHighlightBegin: (height - 20) / 2
        preferredHighlightEnd: (height + 20) / 2
        highlightRangeMode: ListView.StrictlyEnforceRange
        highlightMoveDuration: 800
        highlightMoveSpeed: -1
        currentIndex: root.lineNumber
        delegate: Text {
            text: modelData
            width: view.width
            wrapMode: Text.Wrap
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: platformStyle.fontSizeLarge
            font.family: platformStyle.fontFamilyRegular
            color: ListView.isCurrentItem ? platformStyle.colorNormalLight
                                          : platformStyle.colorNormalMid
        }
        MouseArea {
            anchors.fill: parent
            onClicked: root.clicked()
						//k r1
						onPressAndHold: root.pressAndHold();
						//k r1
        }
    }

    BusyIndicator {
        anchors.centerIn: parent
        width: platformStyle.graphicSizeLarge
        height: platformStyle.graphicSizeLarge
        visible: loader.loading
        running: true
    }

    Label {
        anchors.centerIn: parent
        visible: !loader.loading && view.count == 0
        text: "暂无歌词"
    }
}
