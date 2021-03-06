import LS from './local_storage'

let NewsUpdate = {};

NewsUpdate.initialize = function() {
  if (!$("#news-updates").length) {
    return;
  }

  var key = $("#news-updates").data("id").toString();

  if (LS.get("news-ticker") === key) {
    $("#news-updates").hide();
  } else {
    $("#news-updates").show();

    $("#close-news-ticker-link").on("click.danbooru", function(e) {
      $("#news-updates").hide();
      LS.put("news-ticker", key);

      return false;
    });
  }
}

$(function() {
  NewsUpdate.initialize();
});

export default NewsUpdate
