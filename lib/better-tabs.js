var BetterTabs, BetterTabsView, CompositeDisposable;

BetterTabsView = require('./better-tabs-view');

CompositeDisposable = require('atom').CompositeDisposable;

module.exports = BetterTabs = {
  betterTabsView: null,
  modalPanel: null,
  subscriptions: null,
  activate: function(state) {
    this.betterTabsView = new BetterTabsView(state.betterTabsViewState);
    this.modalPanel = atom.workspace.addModalPanel({
      item: this.betterTabsView.getElement(),
      visible: false
    });
    this.subscriptions = new CompositeDisposable;
    return this.subscriptions.add(atom.commands.add('atom-workspace', {
      'better-tabs:toggle': (function(_this) {
        return function() {
          return _this.toggle();
        };
      })(this)
    }));
  },
  deactivate: function() {
    this.modalPanel.destroy();
    this.subscriptions.dispose();
    return this.betterTabsView.destroy();
  },
  serialize: function() {
    return {
      betterTabsViewState: this.betterTabsView.serialize()
    };
  },
  toggle: function() {
    var somePane, tabBar;
    somePane = atom.workspace.getActivePane();
    tabBar = atom.views.getView(atom.workspace.getActivePane()).querySelector('.tab-bar');
    tabBar.children[0].scrollIntoView(false);
    tabBar.scrollLeft = tabBar.children[0].offsetLeft - 20;
    console.log(atom);
    console.log('BetterTabs was toggled!');
    if (this.modalPanel.isVisible()) {
      return this.modalPanel.hide();
    } else {
      this.betterTabsView._createList();
      return this.modalPanel.show();
    }
  }
};
