$('<%= "#post-#{@post.id}-rating" %>').html('<%= escape_javascript "#{@post.rating}" %>').effect('highlight', {color: 'green' }, 1200);
