BetterTabsView = require './better-tabs-view'
{CompositeDisposable} = require 'atom'

module.exports = BetterTabs =
    betterTabsView: null
    modalPanel: null
    subscriptions: null

    activate: (state) ->
        @betterTabsView = new BetterTabsView(state.betterTabsViewState)
        @modalPanel = atom.workspace.addModalPanel(item: @betterTabsView.getElement(), visible: false)

        # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
        @subscriptions = new CompositeDisposable

        # Register command that toggles this view
        @subscriptions.add atom.commands.add 'atom-workspace', 'better-tabs:toggle': => @toggle()

    deactivate: ->
        @modalPanel.destroy()
        @subscriptions.dispose()
        @betterTabsView.destroy()

    serialize: ->
        betterTabsViewState: @betterTabsView.serialize()

    toggle: ->
        somePane = atom.workspace.getActivePane()
        tabBar = atom.views.getView(atom.workspace.getActivePane()).querySelector('.tab-bar')
        tabBar.children[0].scrollIntoView(false)
        tabBar.scrollLeft = tabBar.children[0].offsetLeft - 20 # TODO: Or whatever the tab ::before thing is
        console.log atom

        # console.log somePane
        # console.log somePane.getTopPanels()  # TODO: BROKEN
        # console.log atom.workspace.getPanel
        # console.log atom.workspace.getModalPanels()
        console.log 'BetterTabs was toggled!'

        if @modalPanel.isVisible()
            @modalPanel.hide()
        else
            @betterTabsView._createList()
            @modalPanel.show()
