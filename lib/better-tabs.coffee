BetterTabsView = require './better-tabs-view'
{CompositeDisposable} = require 'atom'

module.exports = BetterTabs =
    betterTabsView: null
    modalPanel: null
    subscriptions: null

    activate: (state) ->
        @betterTabsView = new BetterTabsView(state.betterTabsViewState)
        @modalPanel = atom.workspace.addModalPanel(item: @betterTabsView.getElement(), visible: false)

        # TODO: This doesn't work if package is activated immediately
        # @tabBarElement = @_getTabBarElement()

        # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
        @subscriptions = new CompositeDisposable

        # Register command that toggles this view
        @subscriptions.add atom.commands.add 'atom-workspace', 'better-tabs:toggle': => @toggle()

        @subscriptions.add atom.workspace.onDidChangeActivePaneItem (item) =>
            @_scrollTabIntoView @_getItemIndex(item)

    deactivate: ->
        @modalPanel.destroy()
        @subscriptions.dispose()
        @betterTabsView.destroy()

    serialize: ->
        betterTabsViewState: @betterTabsView.serialize()

    # TODO: This whole thing can probably go
    toggle: ->
        console.log 'BetterTabs was toggled!'

        if @modalPanel.isVisible()
            @modalPanel.hide()
        else
            @betterTabsView._createList()
            @modalPanel.show()

    # TODO: This doens't work if the pane is still loading
    _getTabBarElement: ->
        atom.views.getView(atom.workspace.getActivePane()).querySelector('.tab-bar')

    _scrollTabIntoView: (index) ->
        tabBarElement = @_getTabBarElement()
        if tabBarElement isnt null
            tabElement = tabBarElement.children[index]
            if tabElement
                switch @_tabIsVisible(tabElement)
                    when 'RIGHT_ONLY'
                        tabBarElement.scrollLeft = tabElement.offsetLeft - 20 # TODO: Or whatever the tab ::before thing is
                    when 'LEFT_ONLY'
                        tabBarElement.scrollLeft = ((tabElement.offsetLeft + tabElement.offsetWidth) - tabBarElement.offsetWidth) + 20

    _getItemIndex: (item) ->
        items = atom.workspace.getPaneItems()
        items.indexOf item

    _tabIsVisible: (tab) ->
        tabBarElement = @_getTabBarElement()
        leftVisible = tabBarElement.scrollLeft < (tab.offsetLeft - 20)

        rightOfBar = tabBarElement.offsetWidth + tabBarElement.scrollLeft
        rightOfTab = tab.offsetWidth + tab.offsetLeft
        rightVisible = rightOfBar > rightOfTab

        if leftVisible and rightVisible
            'VISIBLE'
        else if leftVisible
            'LEFT_ONLY'
        else if rightVisible
            'RIGHT_ONLY'
        else
            'NOT_VISIBLE' # TODO: It's never this value
