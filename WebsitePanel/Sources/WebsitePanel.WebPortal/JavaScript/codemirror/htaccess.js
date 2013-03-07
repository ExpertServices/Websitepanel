CodeMirror.defineMode('shell', function() {

  var words = {};
  function define(style, string) {
    var split = string.split(' ');
    for(var i = 0; i < split.length; i++) {
      words[split[i]] = style;
    }
  };

  // Atoms
  define('atom', 'On Off yes no');

  // Keywords
  //define('keyword', 'Files Location');

  // Commands
  define('builtin', 'AddInputFilter AddLanguage AddModuleInfo AddOutputFilter AddOutputFilterbyType AddType Alias AliasMatch Allow AllowConnect AllowEncodedslashes AllowOverride Anonymous Anonymous_LogEmail Anonymous_MustGiveEmail Anonymous_NoUserid Anonymous_VerifyEmail AuthBasicAuthoritative AuthBasicProvider AuthDbdUserpwQuery AuthDbdUserRealmQuery AuthDbmGroupFile AuthDbmType AuthDbmUserFile AuthDefaultAuthoritative AuthDigestAlgorithm AuthDigestDomain AuthDigestProvider AuthGroupFile AuthName AuthType AuthUserFile AuthzDbmAuthoritative AuthzDbmType AuthzDefaultAuthoritative AuthzGroupFileAuthoritative AuthzOwnerAuthoritative AuthzUserAuthoritative BalancerMember BrowserMatch BrowserMatchnocase CacheDebugHeader CacheDefaultExpire CacheDirLength CacheDirLevels CacheDisable CacheEnable CacheFile CacheignoreCachecontrol CacheignoreHeaders CacheignoreNoLastMod CacheignoreQueryString CacheLastModifiedFactor CacheMaxExpire CacheMaxFileSize CacheMinFileSize CacheRoot CacheStoreNoStore CacheStorePrivate CacheVaryByHeaders CacheVaryByParams CheckCaseOnly CheckSpelling CheckBaseName CookieDomain CookieExpires CookieLog CookieName Cookiestyle Cookietracking CustomLog DbdKeep DbdMax DbdMin DbdParams DbdPersist DbdPrepareSql DbDriver Deny DirectoryIndex DirectoryMatch DirectorySlash DOSHashTableSize DOSWhiteList DOSPageCount DOSsiteCount DOSPageInterval DOSsiteInterval DOSBlockingPeriod DOSCloseSocket DOSSystemCommand ErrorDocument ErrorLog ExpiresActive ExpiresByType ExpiresDefault FilterChain FilterDeclare FilterProtocol FilterProvider FreeSites GracefulShutdownTimeout Group Header HeaderName HostNameLookups Include KeepAlive keepAliveTimeout Listen ListenBackLog LoadFile LoadModule LockFile LogFormat LogLevel MCacheMaxObjectCount MCacheMaxObjectSize MCacheMaxStreaMingBuffer MCacheMinObjectSize MCacheRemovalAlgorithm MCacheSize mod_gzip_on  mod_gzip_add_header_count  mod_gzip_compression_level  mod_gzip_keep_workfiles mod_gzip_dechunk mod_gzip_min_http mod_gzip_minimum_file_size mod_gzip_maximum_file_size mod_gzip_maximum_inmem_size mod_gzip_temp_dir mod_gzip_item_include mod_gzip_item_exclude mod_gzip_command_version mod_gzip_can_negotiate mod_gzip_handle_methods mod_gzip_static_suffix mod_gzip_send_vary mod_gzip_update_static NameVirtualHost NoProxy Options Order PassEnv ProxyBadHeader ProxyBlock ProxyDomain ProxyErrorOverride ProxyIoBufferSize ProxyMaxForwards ProxyPass ProxyPassinterpolateEnv ProxyPassMatch ProxyPassReverse ProxyPassReverseCookieDomain ProxyPassReverseCookiepath ProxyPreserveHost ProxyReceiveBufferSize ProxyRemote ProxyRemoteMatch ProxyRequests ProxySet ProxyStatus ProxyTimeout ProxyVia ReceiveBufferSize Redirect RedirectMatch Redirectpermanent Redirecttemp RegistrationName Registrationcode RemoveHandler RemoveInputFilter RemoveLanguage RemoveOutputFilter RemoveType ReplaceFilterDefine ReplacePattern RequestHeader Require RewriteBase RewriteCond RewriteEngine RewriteHeader RewriteLock RewriteLog RewriteLogLevel RewriteMap RewriteOptions RewriteRule RewriteProxy Satisfy SendBufferSize ServerAdmin ServerAlias ServerLimit ServerName ServerPath ServerRoot ServerSignature ServerTokens SetEnv SetEnvif SetEnvifnocase SetHandler SetInputFilter SetOutputFilter SeoRule Substitute Timeout TraceEnable TransferLog TypesConfig UnsetEnv UseCanonicalName UseCanonicalPhysicalPort UserDir VirtualDocumentRoot VirtualDocumentRootip VirtualscriptAlias VirtualscriptAliasIp HotlinkInvolveIp HotlinkExpires HotlinkProtect HotlinkSignature HotlinkType HotlinkError HotlinkAllow HotlinkDeny LinkFreezeEngine LinkFreezePageSizeLimit LinkFreezeRule');

  function tokenBase(stream, state) {

    var sol = stream.sol();
    var ch = stream.next();

    if (ch === '\'' || ch === '"' || ch === '`') {
      state.tokens.unshift(tokenString(ch));
      return tokenize(stream, state);
    }
    if (ch === '#') {
      if (sol && stream.eat('!')) {
        stream.skipToEnd();
        return 'meta'; // 'comment'?
      }
      stream.skipToEnd();
      return 'comment';
    }
    if (ch === '$') {
      state.tokens.unshift(tokenDollar);
      return tokenize(stream, state);
    }
    if (ch === '+' || ch === '=') {
      return 'operator';
    }
    if (ch === '<') {
      stream.eat('/');
      stream.eatWhile(/[^>]/);
      return 'attribute';
    }
    if (ch === '>') { 
     return 'attribute';
    }

    /*
    if (ch === '-') {
      stream.eat('-');
      stream.eatWhile(/\w/);
      return 'attribute';
    }
    */
    if (/\d/.test(ch)) {
      stream.eatWhile(/\d/);
      if(!/\w/.test(stream.peek())) {
        return 'number';
      }
    }
    stream.eatWhile(/\w/);
    var cur = stream.current();
    if (stream.peek() === '=' && /\w+/.test(cur)) return 'def';
    return words.hasOwnProperty(cur) ? words[cur] : null;
  }

  function tokenString(quote) {
    return function(stream, state) {
      var next, end = false, escaped = false;
      while ((next = stream.next()) != null) {
        if (next === quote && !escaped) {
          end = true;
          break;
        }
        if (next === '$' && !escaped && quote !== '\'') {
          escaped = true;
          stream.backUp(1);
          state.tokens.unshift(tokenDollar);
          break;
        }
        escaped = !escaped && next === '\\';
      }
      if (end || !escaped) {
        state.tokens.shift();
      }
      return (quote === '`' || quote === ')' ? 'quote' : 'string');
    };
  };

  var tokenDollar = function(stream, state) {
    if (state.tokens.length > 1) stream.eat('$');
    var ch = stream.next(), hungry = /\w/;
    if (ch === '{') hungry = /[^}]/;
    if (ch === '(') {
      state.tokens[0] = tokenString(')');
      return tokenize(stream, state);
    }
    if (!/\d/.test(ch)) {
      stream.eatWhile(hungry);
      stream.eat('}');
    }
    state.tokens.shift();
    return 'def';
  };

  function tokenize(stream, state) {
    return (state.tokens[0] || tokenBase) (stream, state);
  };

  return {
    startState: function() {return {tokens:[]};},
    token: function(stream, state) {
      if (stream.eatSpace()) return null;
      return tokenize(stream, state);
    }
  };
});
  
CodeMirror.defineMIME('text/x-sh', 'shell');
