sm = new SubsManager()
FlowRouter.globals.push title: 'Default title'

FlowRouter.notFound = 
  action: -> BlazeLayout.render '_layout', content: '_404', rand: Random.id()
  title: '404: Page not found'

FlowRouter.route '/',
  name: 'index'
  action: -> BlazeLayout.render '_layout', content: 'index', rand: Random.id()

FlowRouter.route '/secondPage',
  name: 'secondPage'
  title: 'Second Page title'
  action: -> BlazeLayout.render '_layout', content: 'secondPage', rand: Random.id()

FlowRouter.route '/thirdPage/:something',
  name: 'thirdPage'
  title: -> "Third Page Title > #{@params.something}"
  action: (params, query) -> BlazeLayout.render '_layout', content: 'thirdPage', rand: params.something

group = FlowRouter.group prefix: '/group', title: "GROUP TITLE", titlePrefix: 'Group > '

group.route '/groupPage1',
  name: 'groupPage1'
  action: (params, query) -> BlazeLayout.render '_layout', content: 'groupPage1', rand: Random.id()

group.route '/groupPage2',
  name: 'groupPage2'
  title: 'Group page 2'
  action: (params, query) -> BlazeLayout.render '_layout', content: 'groupPage2', rand: Random.id()

FlowRouter.route '/post',
  name: 'post'
  title: (params, query, post) -> post?.title
  action: (params, query, post) -> BlazeLayout.render '_layout', content: 'post', post: post, rand: Random.id()
  waitOn: -> [sm.subscribe('posts')]
  data: -> Collections.posts.findOne()
  whileWaiting: -> BlazeLayout.render '_layout', content: '_loading'

FlowRouter.route '/post/:_id',
  name: 'post.id'
  title: (params, query, post) -> if post then post?.title else '404: Page not found'
  action: (params, query, post) -> BlazeLayout.render '_layout', content: 'post', post: post, rand: Random.id()
  waitOn: -> [sm.subscribe('posts')]
  data: (params) -> Collections.posts.findOne(params._id)
  onNoData:     -> BlazeLayout.render '_layout', content: '_404', rand: Random.id()
  whileWaiting: -> BlazeLayout.render '_layout', content: '_loading'

new FlowRouterTitle FlowRouter