/*
Parse Messages from a Skype conversation in to a JSON Object

jens a. ewald, ififelse.net, 2012, licensed by the unlicence
*/
var __indexOf = Array.prototype.indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

String.prototype.parsefromSykpe = function() {
  var d, e, h, iswin, k, keys, lasttime, lastuser, m, macparser, message, mo, parser, s, user, y, _blob, _res, _result, _results;
  iswin = this.match(/^\[\d{2}/);
  parser = iswin ? /(\[((\d{2}).(\d{2}).(\d{4}))\s((\d{2})\:(\d{2})\:(\d{2}))\]\s(.*)\:\s)((.|(\r\n[^\[\d\.]{9}))+)/g : macparser = /((((.*)\s((\d+)\.(\d+)\.(\d+)\s+(\d+):(\d+))(?=\s|\n))((.|(\n(?!.*\d{2}\.)))+)))/g;
  _results = [];
  while (_result = parser.exec(this)) {
    keys = iswin ? [3, 4, 5, 7, 8, 9, 10, 11] : [6, 7, 8, 9, 10, 4, 11];
    _res = (function() {
      var _ref, _results2;
      _results2 = [];
      for (k in _result) {
        e = _result[k];
        if (_ref = parseInt(k), __indexOf.call(keys, _ref) >= 0) _results2.push(e);
      }
      return _results2;
    })();
    if (iswin) {
      d = _res[0], mo = _res[1], y = _res[2], h = _res[3], m = _res[4], s = _res[5], user = _res[6], message = _res[7];
    } else {
      user = _res[0], d = _res[1], mo = _res[2], y = _res[3], h = _res[4], m = _res[5], message = _res[6];
      y = "20" + y;
    }
    _blob = {
      User: user || lastuser,
      Text: message,
      Zeit: new Date(y, mo, d, h, m, s != null ? s : 0) || lasttime,
      Komentar: ""
    };
    lastuser = _blob.User;
    lasttime = _blob.Zeit;
    _results.push(_blob);
  }
  return _results;
};
