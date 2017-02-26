#!/usr/bin/perl
use CGI;
use JSON;
use LWP::UserAgent;
my $cgi  = new CGI();
my $json = new JSON();
my $ua   = new LWP::UserAgent();

# API認証情報
my $API_URI               = "https://api.line.me/v2/bot/message/reply";
my $CHANNEL_ACCCESS_TOKEN = "xxxxx"; # LINE developersから取得したtokenを指定

# LINEからPOST受信
my $source = $cgi->param('POSTDATA');
my $items  = $json->decode($source);
my $event  = $items->{events}[0];

# replyToken、投稿内容取得
my $reply_token = $event->{replyToken};
my $reply_text  = $event->{message}->{text};

# LINEに200を返す
print "Status: 200 OK\n";
print "Content-Type: text/html\n\n";

# 返信メッセージ作成、JSONエンコード
my $data = {
	"replyToken" => $reply_token,
	"messages"   => [
		{"type"  => "text", "text" => "復唱するよ。"},
		{"type"  => "text", "text" => $reply_text}
	]
};
my $content = $json->utf8(0)->encode($data);

# POSTリクエスト生成
my $req = HTTP::Request->new("POST", $API_URI);
$req->header("Content-Type"  => "application/json");
$req->header("Authorization" => "Bearer $CHANNEL_ACCCESS_TOKEN");
$req->content($content);

# POST送信
$ua->request($req);
