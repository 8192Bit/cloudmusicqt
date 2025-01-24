import QtQuick 1.0
import com.nokia.symbian 1.0
import com.yeatse.cloudmusic 1.0

import "../js/api.js" as Api

Page {
    id: page

    property string userId
    property bool requestLoad: true

    property bool loadingUserData: false
    property bool loadingPlayList: false
    property bool userDataValid: false

    property string avatarImageUrl
    property string userName
    property int gender // 1 for male, 2 for female
    property int eventCount
    property int followingCount
    property int followerCount
    property string signature
    property int playlistCreated
    property int playlistSubscribed

    orientationLock: PageOrientation.LockPortrait

    onStatusChanged: {
        if (status == PageStatus.Active && requestLoad) {
            requestLoad = false
            loadUserData()
            loadUserPlayList()
        }
    }

    function loadUserData() {
        if (loadingUserData) return;
        var s = function(resp) {
            loadingUserData = false
            var profile = resp.profile
            avatarImageUrl = profile.avatarUrl
            userName = profile.nickname
            gender = profile.gender
            eventCount = profile.eventCount
            followingCount = profile.follows
            followerCount = profile.followeds
            signature = profile.signature
            playlistCreated = profile.cCount
            playlistSubscribed = profile.sCount
            userDataValid = true
        }
        var f = function(err) {
            loadingUserData = false
            console.log("load user data err:", err)
        }
        loadingUserData = true
        Api.getUserDetail(userId, s, f)
    }

    function loadUserPlayList() {
        if (loadingPlayList) return
        var s = function(resp) {
            loadingPlayList = false
            listModel.clear()
            for (var i in resp.playlist) {
                var prop = resp.playlist[i]
                prop.group = prop.creator.userId == userId ? 0 : 1
                listModel.append(prop)
            }
        }
        var f = function(err) {
            loadingPlayList = false
            console.log("get user playlist failed: ", err)
        }
        loadingPlayList = true
        Api.getUserPlayList(userId, s, f)
    }

    tools: ToolBarLayout {
        ToolButton {
            iconSource: "toolbar-back"
            onClicked: pageStack.pop()
        }
        ToolButton {
            iconSource: "gfx/logo_icon.png"
            onClicked: player.bringToFront()
        }
        ToolButton {
            iconSource: "toolbar-menu"
            onClicked: logoffMenu.open()
        }

    }

    Menu {
        id: logoffMenu
        MenuItem {
            text: "退出登录"
            onClicked: logoutDiagComp.createObject(page)

            Component {
                id: logoutDiagComp
                CommonDialog {
                    id: diag
                    property bool isClosing: false
                    titleText: "提示"
                    content: Item {
                        width: diag.platformContentMaximumWidth
                        height: contentCol.height + platformStyle.paddingLarge * 2
                        Column {
                            id: contentCol
                            anchors {
                                left: parent.left; right: parent.right
                                top: parent.top; margins: platformStyle.paddingLarge
                            }
                            spacing: platformStyle.paddingMedium
                            Label {
                                width: parent.width
                                wrapMode: Text.Wrap
                                text: "确定要退出登录吗？"
                            }
                            ButtonRow {
                                anchors.left: parent.left
                                anchors.right: parent.right
                                Button {
                                    id: okButton
                                    text: "确定"

                                    onClicked: {
                                        qmlApi.logout()
                                        user.initialize()
                                        diag.close()
                                        pageStack.pop()
                                    }
                                }
                                Button {
                                    id: cancelButton
                                    text: "取消"
                                    onClicked: diag.close()
                                }
                            }
                        }
                    }
                    Component.onCompleted: open()
                    onStatusChanged: {
                        if (status == DialogStatus.Closing)
                            isClosing = true
                        else if (status == DialogStatus.Closed && isClosing)
                            diag.destroy()
                    }
                }
            }
        }
    }

    ListView {
        id: listView
        anchors.fill: parent
        model: ListModel { id: listModel }
        header: Column {
            width: listView.width
            spacing: platformStyle.paddingLarge
            ViewHeader {
                title: "个人主页"
            }
            Item {
                anchors { left: parent.left; right: parent.right; margins: platformStyle.paddingLarge }
                height: 120
                visible: loadingUserData || !userDataValid
                BusyIndicator {
                    anchors.centerIn: parent
                    running: loadingUserData
                }
                Button {
                    anchors.centerIn: parent
                    iconSource: privateStyle.toolBarIconPath("toolbar-refresh")
                    visible: !loadingUserData && !userDataValid
                    onClicked: loadUserData()
                }
            }
            Item {
                anchors { left: parent.left; right: parent.right; margins: platformStyle.paddingLarge }
                height: 120
                visible: !loadingUserData && userDataValid
                Image {
                    id: avatarImage
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.height
                    height: width
                    source: avatarImageUrl
                    sourceSize { width: width; height: height }
                }
                ListItemText {
                    id: nameLabel
                    anchors {
                        left: avatarImage.right; leftMargin: platformStyle.paddingMedium
                        top: parent.top; topMargin: platformStyle.paddingSmall
                    }
                    text: userName
                }
                ListItemText {
                    id: introLabel
                    anchors {
                        left: nameLabel.left; top: nameLabel.bottom; right: parent.right
                        topMargin: platformStyle.paddingSmall
                    }
                    role: "SubTitle"
                    wrapMode: Text.Wrap
                    //maximumLineCount: 2
                    text: signature
                }
                ListItemText {
                    anchors {
                        left: nameLabel.left; bottom: parent.bottom
                        bottomMargin: platformStyle.paddingSmall
                    }
                    role: "SubTitle"
                    text: "动态%1 关注%2 粉丝%3".arg(eventCount).arg(followingCount).arg(followerCount)
                }
            }
            Item { width: 1; height: 1 }
        }
        section {
            property: "group"
            delegate: ListHeading {
                ListItemText {
                    anchors.fill: parent.paddingItem
                    role: "Heading"
                    text: section == 0 ? "创建的歌单%1".arg(page.playlistCreated)
                                       : "收藏的歌单%1".arg(page.playlistSubscribed)
                }
            }
        }
        delegate: CategoryListItem {
            title: name
            iconSource: Api.getScaledImageUrl(coverImgUrl, 80)
            onClicked: {
                var prop = { listId: id }
                pageStack.push(Qt.resolvedUrl("PlayListPage.qml"), prop)
            }
        }
        footer: Item {
            width: listView.width
            height: loadingPlayList && !loadingUserData ? 200 : 0
            BusyIndicator {
                anchors.centerIn: parent
                running: loadingPlayList && !loadingUserData
                visible: running
            }
        }
    }

    ScrollDecorator { flickableItem: listView }
}
