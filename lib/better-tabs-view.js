var BetterTabsView;

module.exports = BetterTabsView = (function() {
  function BetterTabsView(serializedState) {
    var message;
    this.element = document.createElement('div');
    this.element.classList.add('better-tabs');
    message = document.createElement('div');
    this.ulEl = document.createElement('ul');
    message.classList.add('message');
    message.appendChild(this.ulEl);
    this.element.appendChild(message);
    this._createList();
  }

  BetterTabsView.prototype.serialize = function() {};

  BetterTabsView.prototype.destroy = function() {
    return this.element.remove();
  };

  BetterTabsView.prototype.getElement = function() {
    return this.element;
  };

  BetterTabsView.prototype._createList = function() {
    var doc, docs, i, len, liElm, ref, results;
    this._removeItems();
    docs = atom.workspace.getPaneItems();
    results = [];
    for (i = 0, len = docs.length; i < len; i++) {
      doc = docs[i];
      liElm = this._addItem((doc.getTitle()) + " - " + (typeof doc.getGrammar === "function" ? (ref = doc.getGrammar()) != null ? ref.name : void 0 : void 0));
      if (typeof doc.isModified === "function" ? doc.isModified() : void 0) {
        results.push(liElm.classList.add('modified'));
      } else {
        results.push(void 0);
      }
    }
    return results;
  };

  BetterTabsView.prototype._addItem = function(name) {
    var newLi;
    newLi = document.createElement('li');
    newLi.textContent = name;
    this.ulEl.appendChild(newLi);
    return newLi;
  };

  BetterTabsView.prototype._removeItems = function() {
    var results;
    results = [];
    while (this.ulEl.firstChild) {
      results.push(this.ulEl.removeChild(this.ulEl.firstChild));
    }
    return results;
  };

  return BetterTabsView;

})();
