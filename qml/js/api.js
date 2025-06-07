.pragma library

var qmlApi;

var CloudMusicApi = {
    SNS_AUTH_SINA: "http://music.163.com/api/sns/authorize/?snsType=2&clientType=pc",
    //k r1 LOGIN_TOKEN_REFRESH: "http://music.163.com/api/login/token/refresh",
    LOGIN_TOKEN_REFRESH: "http://music.163.com/weapi/login/token/refresh",

    DISCOVERY_RECOMMEND_RESOURCE: "http://music.163.com/api/v1/discovery/recommend/resource",
    DISCOVERY_HOTSPOT: "http://music.163.com/api/discovery/hotspot",

    USER_DETAIL: "http://music.163.com/api/user/detail/",
    USER_PLAYLIST: "http://music.163.com/api/user/playlist/",

    RADIO_LIKE: "http://music.163.com/api/radio/like",
    RADIO_TRASH_ADD: "http://music.163.com/api/radio/trash/add",

    RESOURCE_COMMENTS: "http://music.163.com/api/v1/resource/comments/",

    PLAYLIST_SUBSCRIBE: "http://music.163.com/api/playlist/subscribe/",
    PLAYLIST_UNSUBSCRIBE: "http://music.163.com/api/playlist/unsubscribe/",

    //8192Bit
    LOGIN_QR_KEY_GENERATE: "http://music.163.com/api/login/qrcode/unikey",
    USER_DETAIL_FROM_COOKIE: "http://music.163.com/api/nuser/account/get"
};

var ApiRequest = function(url, method) {
    this.url = url;
    this.method = method || "GET";
    this.query = "";
    this.postData = "";
};

ApiRequest.prototype.setQuery = function(query) {
            for (var k in query) {
                this.query += this.query == "" ? "?" : "&";
                this.query += k + "=" + encodeURIComponent(query[k]);
            }
        };

ApiRequest.prototype.setParams = function(params) {
            for (var k in params) {
                if (this.postData != "")
                    this.postData += "&";

                this.postData += k + "=" + encodeURIComponent(params[k]);
            }
        };

ApiRequest.prototype.sendRequest = function(onSuccess, onFailure) {
            var xhr = new XMLHttpRequest();
            xhr.onreadystatechange = function() {
                        if (xhr.readyState == XMLHttpRequest.DONE) {
                            if (xhr.status == 200) {
                                try {
                                    var resp = qmlApi.jsonParse(xhr.responseText)
                                                                            //console.log(xhr.responseText);
                                    if (!resp || resp.code == 200) //k r1 token refresh api response a empty content.
                                        onSuccess(resp);
                                    else
                                        onFailure(resp.code)
                                }
                                catch (e) {
                                    onFailure(e.toString());
                                }
                            }
                            else {
                                onFailure(xhr.status);
                            }
                        }
                    };
            xhr.open(this.method, this.url + this.query);
                        //k console.log(this.url + this.query);
            if (this.method == "POST") {
                xhr.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
                xhr.setRequestHeader("Content-Length", this.postData.length);
                xhr.send(this.postData);
            }
            else {
                xhr.send(null);
            }
        };

function getScaledImageUrl(url, size) {
    return url + "?param=%1y%1&quality=100".arg(size);
}

function refreshToken(token, onSuccess, onFailure) {
    var req = new ApiRequest(CloudMusicApi.LOGIN_TOKEN_REFRESH, "POST");
    req.setParams({ cookieToken: token });
    req.sendRequest(onSuccess, onFailure);
}

function getRecommendResource(onSuccess, onFailure) {
    var req = new ApiRequest(CloudMusicApi.DISCOVERY_RECOMMEND_RESOURCE);
    req.setQuery({limit: 5});
    req.sendRequest(onSuccess, onFailure);
}

function getHotSopt(onSuccess, onFailure) {
    var req = new ApiRequest(CloudMusicApi.DISCOVERY_HOTSPOT);
    req.setQuery({limit: 12});
    req.sendRequest(onSuccess, onFailure);
}

function getUserDetail(uid, onSuccess, onFailure) {
    var req = new ApiRequest(CloudMusicApi.USER_DETAIL + uid);
    req.setQuery({userId: uid, all: true});
    req.sendRequest(onSuccess, onFailure);
}

function getUserPlayList(uid, onSuccess, onFailure) {
    var req = new ApiRequest(CloudMusicApi.USER_PLAYLIST);
    req.setQuery({ offset: 0, limit: 1000, uid: uid });
    req.sendRequest(onSuccess, onFailure);
}

function collectRadioMusic(option, onSuccess, onFailure) {
    var req = new ApiRequest(CloudMusicApi.RADIO_LIKE);
    var query = {
        alg: "itembased",
        trackId: option.id,
        like: option.like,
        time: option.sec
    };
    req.setQuery(query);
    req.sendRequest(onSuccess, onFailure);
}

function addRadioMusicToTrash(option, onSuccess, onFailure) {
    var req = new ApiRequest(CloudMusicApi.RADIO_TRASH_ADD);
    var query = {
        alg: "itembased",
        songId: option.id,
        time: option.sec
    };
    req.setQuery(query);
    req.sendRequest(onSuccess, onFailure);
}

function getCommentList(option, onSuccess, onFailure) {
    var req = new ApiRequest(CloudMusicApi.RESOURCE_COMMENTS + option.rid);
    var query = {
        rid: option.rid,
        offset: option.offset,
        total: option.total,
        limit: 20
    };
    req.setQuery(query);
    req.sendRequest(onSuccess, onFailure);
}

function subscribePlaylist(option, onSuccess, onFailure) {
    var req;
    if (option.subscribe)
        req = new ApiRequest(CloudMusicApi.PLAYLIST_SUBSCRIBE);
    else
        req = new ApiRequest(CloudMusicApi.PLAYLIST_UNSUBSCRIBE);

    var query = { id: option.id };
    req.setQuery(query);
    req.sendRequest(onSuccess, onFailure);
}

//8192Bit
function generateQrKey(onSuccess, onFailure) {
    var req = new ApiRequest(CloudMusicApi.LOGIN_QR_KEY_GENERATE);
    req.setQuery({ type: 3 });
    req.sendRequest(onSuccess, onFailure);
}
/*
function loginByEmail(email, password, onSuccess, onFailure) {
    var req = new ApiRequest(CloudMusicApi.LOGIN_NETEASE_EMAIL);
    var query = {
        type: '0',
        https: 'true',
        username: email,
        password: qmlApi.calculateMD5(password),
        rememberLogin: 'true'
    };
    req.setQuery(query);
    req.sendRequest(onSuccess, onFailure);
}
*/

function getUserDetailByCookie(onSuccess, onFailure) {
    var req = new ApiRequest(CloudMusicApi.USER_DETAIL_FROM_COOKIE);
    req.sendRequest(onSuccess, onFailure);
}

function getHttpUrl(url) {
    return url.replace("https://", "http://")
}
