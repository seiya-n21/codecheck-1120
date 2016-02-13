/* -----------------------------------------------------------------
 *  タイマー管理用のライブラリ
 *  --> connect_apiにて、満室判定ならcallされる
 * ----------------------------------------------------------------- */

// 再帰呼び出しで利用
var target_time;
var fix_time;

function display_timer(){ //再帰呼び出し
  var now_time = (new Date).getTime();
  var left_time = (target_time - now_time - fix_time)/1000; // 1,000 ms -> 1 s

  if(left_time < 0){ // 終了判定・処理
    logging_debug('ridirect to: ' + VOTE_URL);
    multiparty.close(); // multipartyインスタンスclose
    $(window).off('beforeunload');
    location.href=VOTE_URL; //redirect to vote
  } else {
    // m:残時間を60でわった値  s:残時間を60で割った余り
    var m = Math.floor(left_time / 60);
    var s = Math.floor(left_time % 60);
    s = (s < 0) ? 0 : s; //マイナスならないよう修正
    var s_timer = ( (m > 0) ? (m + '分' + s + '秒') : (s + '秒') );
    $("#room_timer").html('<p id="timer_counter" > 終了まで' + s_timer + '</p>');
  }
}

// target_time: Serverから返却された時間を基にTarget決める
// fix_time:    ローカル時刻とサーバ時刻から差分を補正する
function set_timer_variable(server_target_time){
  st = new Date(server_target_time);
  var ct = new Date();
  var client_time = ct.getTime();

  fix_time = st.getTime() - client_time;
  // TODO: 600は、gon.const.video_time　に置き換え
  d = new Date();
  target_time  = d.setTime(st.getTime() + (10 * 60 * 1000) ); 
  logging_debug('server_time:  ');
  logging_debug(d.getTime());
  logging_debug('client_time:  ');
  logging_debug(client_time);
  logging_debug('fix_time:  ');
  logging_debug(fix_time);
  logging_debug('target_time:  ');
  logging_debug(target_time);
}

function count_timer(server_target_time){//connect_apiにて、満室判定ならcallされる
  set_timer_variable(server_target_time);
  setInterval("display_timer()",1000);
}