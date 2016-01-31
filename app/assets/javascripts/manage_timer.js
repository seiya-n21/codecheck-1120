/* -----------------------------------------------------------------
 * GoCon room タイマー管理用のライブラリ
 *  --> connect_apiにて、満室判定ならcallされる
 * ----------------------------------------------------------------- */

d = new Date();
var target_time  = d.setSeconds(d.getSeconds() + 600);
logging_debug('target_time:  ');
logging_debug(target_time);

/*
var nowt = (new Date).getTime();
logging_debug('now time:  ');
logging_debug(nowt);
var left_time = (target_time - nowt)/1000; // 1,000 ms -> 1 s
logging_debug('left_time:  ');
logging_debug(left_time);
*/
//var left_time = gon.const.video_time; //再帰呼び出しで利用するため、グローバル変数にする

function display_timer(){
   //  left_time = left_time - 1;
  var now_time = (new Date).getTime();
  logging_debug('now time:  ');
  logging_debug(now_time);
  var left_time = (target_time - now_time)/1000; // 1,000 ms -> 1 s
  logging_debug('left_time:  ');
  logging_debug(left_time);

  if(left_time < 0){ // 終了判定・処理
    logging_debug('ridirect to: ' + VOTE_URL);
    multiparty.close(); // multipartyインスタンスclose
    $(window).off('beforeunload');
    location.href=VOTE_URL; //redirect to vote
  } else {
    // m:残時間を60でわった値  s:残時間を60で割った余り
    var m = Math.floor(left_time / 60);
    var s = left_time % 60;
    s = (s < 0) ? 0 : s; //マイナスならないよう修正
    var s_timer = ( (m > 0) ? (m + '分' + s + '秒') : (s + '秒') );
    $("#room_timer").html('<p id="timer_counter" > 終了まで' + s_timer + '</p>');
  }
}

//ref)http://iwb.jp/javascript-new-date-gettime/
// TODO: 
//   1. Serverから返却された時間を基にTarget決める
//   2. ローカル時刻とサーバ時刻から差分を補正する
//
function count_timer(server_target_time){
  d = new Date(server_target_time);
  logging_debug(d); //
  var target_time  = d.setSeconds(d.getSeconds() + 600);
  logging_debug('target_time:  ');
  logging_debug(target_time);

  setInterval("display_timer()",1000);
}
