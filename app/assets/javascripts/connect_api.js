/* -----------------------------------------------------------------
 * APIリクエストなど、通信関連のライブラリ
 *
 * ----------------------------------------------------------------- */

var count_flag = false;

//追加するDOMを、性別によって切り替える
function selectElm_wGender(s_gender){
  if (s_gender == 'male'){
    return "#streams-male";
  }else{
    return "#streams-female";
  }
}
//API取得したuinfoのうち、追加されたpeer(wid)の情報を選択
function select_uinfo(wid, resp){
  for(var i=0; i<resp.length; i++){
    var tmp = resp[i];
	　//logging_debug( wid + ' and ' + tmp.id + ' =? ' + (wid == tmp.id) );
	　if (wid == tmp.id){ //windowidが一致した場合に、ユーザ情報を返却
	  　// XSS対策のため、ユーザ入力値はescapeすること
	    var obj = {'wid': tmp.id, 'name': escapeHtml(tmp.name), 'gender': tmp.gender};
	    logging_debug('get obj from 1. Get userinfo API');
	    logging_debug(obj);
	    return obj;
    }
  }
  //objなければfalse返す
  return false;
}

// <div id="stream-(male/female)" >
//   <div id="peer-video-uinfo-[wid]">
//    <video .. >
//    <div id="peer-name-[wid]"> pname:*** pgen:***
function addview_uinfo(video, uinfo, wid){
  // ユーザ枠を追加: <div id = "peer-video-uinfo-[windowid]">
  var pVideoElem = document.createElement('div');
  pVideoElem.setAttribute("id", 'peer-video-uinfo-'+ video['id']);
  logging_debug('peer video obj:');
  logging_debug(video);
  ( $('#peer-video-uinfo-'+ video['id'])[0] )? logging_debug('exist_peer') : $(pVideoElem).appendTo(selectElm_wGender(uinfo['gender']));

  // peerのvideoを表示
  var vNode = MultiParty.util.createVideoNode(video);
  vNode.setAttribute("class", "video peer-video");
  $(vNode).appendTo(pVideoElem);

  //ユーザ情報の表示
  var nameElem = document.createElement('div');
  nameElem.setAttribute("class", "peer-name");
  nameElem.setAttribute("id", "peer-name-" + wid);
  // XSS対策のため、ユーザ入力値はescapeすること
　nameElem.innerHTML = ('pname: ' + escapeHtml(uinfo['name']) + ' <br>  pgender: ' + uinfo['gender']);
  ( $("#peer-name-" + wid)[0] )? logging_debug('exist_peer') : $(nameElem).appendTo("#peer-video-uinfo-" + wid);
}

// ------------------------------------
// 1. Get userinfo API
// ------------------------------------
function display_uinfo(video, roomid){
  var api_url = '/api/v1/window_id/' + video['id'] + '.json?room_id=' + roomid;
  //'/api/v1/users/' + roomid + '.json';
  logging_debug('api connect: url=' + api_url);
  $.ajax({
	  type: "GET",
	  url: api_url,
    dataType: "json",
	  //通信成功時
	  success: function(resp){
		　//var obj = select_uinfo(wid, resp);
		　//logging_debug(obj['name']);
		　//addview_uinfo(obj, wid);
		　logging_debug('api response: url=' + api_url);
		　logging_debug(resp);
		　addview_uinfo(video, resp, video['id']);
	  }
	});
}

// ------------------------------------
// 2. Fullroom API
// ------------------------------------
function check_fullroom(roomid){
  // APIにアクセス
  var api_url = '/api/v1/room_full/' + roomid + '.json';
  //var api_url = '/api/v1/room_full/1.json'; //暫定的に
  logging_debug('api connect: url=' + api_url);
  $.ajax({
    type: "GET",
    url: api_url, //data: [param],
    dataType: "json",
    //通信成功時
    success: function(resp){
      logging_debug('result: ' + '  from:' + api_url);
      logging_debug(resp);
      if (resp.result) {
        count_flag = true;
        count_timer(resp.time);
      }
    }
  });
}

// ------------------------------------
// 3. resist windowid for userDB
// ------------------------------------
function regist_windowid(userid, wid){
  var api_url = '/api/v1/user/' + userid + '.json';
  logging_debug('api connect: url=' + api_url + ' with wid: ' + wid);
  $.ajax({
    type: "PUT",
    url: api_url,
    data: "window_id=" + wid,
    dataType: "json",
      success: function(resp){
    　logging_debug('result: ' + resp.result + '  from:' + api_url);
    }
  });
}

// ------------------------------------
// 4. Delete API
// ------------------------------------
function delete_user(userid){
  var api_url = '/api/v1/leaving_user';
  logging_debug('api connect: url=' + api_url + ' with user id: ' + userid);
  $.ajax({
    type: "PUT",
    url: api_url,
    data: "user_id=" + userid,
    dataType: "json",
    success: function(resp){
    　logging_debug('result: ' + resp.result + '  from:' + api_url);
    }
  });
}
