loadDisqus = function(shortname, title, url, identifier) {
/* * * DON'T EDIT BELOW THIS LINE * * */
var disqus_shortname = shortname;
var disqus_title = title;
var disqus_url = url;
var disqus_identifier = identifier;

/* * * DON'T EDIT BELOW THIS LINE * * */
(function() {
  var dsq = document.createElement('script'); dsq.type = 'text/javascript'; dsq.async = true;
  dsq.src = '//' + disqus_shortname + '.disqus.com/embed.js';
  (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);
})();
}

