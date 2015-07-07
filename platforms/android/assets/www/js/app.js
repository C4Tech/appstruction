(function(/*! Brunch !*/) {
  'use strict';

  var globals = typeof window !== 'undefined' ? window : global;
  if (typeof globals.require === 'function') return;

  var modules = {};
  var cache = {};

  var has = function(object, name) {
    return ({}).hasOwnProperty.call(object, name);
  };

  var expand = function(root, name) {
    var results = [], parts, part;
    if (/^\.\.?(\/|$)/.test(name)) {
      parts = [root, name].join('/').split('/');
    } else {
      parts = name.split('/');
    }
    for (var i = 0, length = parts.length; i < length; i++) {
      part = parts[i];
      if (part === '..') {
        results.pop();
      } else if (part !== '.' && part !== '') {
        results.push(part);
      }
    }
    return results.join('/');
  };

  var dirname = function(path) {
    return path.split('/').slice(0, -1).join('/');
  };

  var localRequire = function(path) {
    return function(name) {
      var dir = dirname(path);
      var absolute = expand(dir, name);
      return globals.require(absolute, path);
    };
  };

  var initModule = function(name, definition) {
    var module = {id: name, exports: {}};
    cache[name] = module;
    definition(module.exports, localRequire(name), module);
    return module.exports;
  };

  var require = function(name, loaderPath) {
    var path = expand(name, '.');
    if (loaderPath == null) loaderPath = '/';

    if (has(cache, path)) return cache[path].exports;
    if (has(modules, path)) return initModule(path, modules[path]);

    var dirIndex = expand(path, './index');
    if (has(cache, dirIndex)) return cache[dirIndex].exports;
    if (has(modules, dirIndex)) return initModule(dirIndex, modules[dirIndex]);

    throw new Error('Cannot find module "' + name + '" from '+ '"' + loaderPath + '"');
  };

  var define = function(bundle, fn) {
    if (typeof bundle === 'object') {
      for (var key in bundle) {
        if (has(bundle, key)) {
          modules[key] = bundle[key];
        }
      }
    } else {
      modules[bundle] = fn;
    }
  };

  var list = function() {
    var result = [];
    for (var item in modules) {
      if (has(modules, item)) {
        result.push(item);
      }
    }
    return result;
  };

  globals.require = require;
  globals.require.define = define;
  globals.require.register = define;
  globals.require.list = list;
  globals.require.brunch = true;
})();
require.register("application", function(exports, require, module) {
var Application, Collection, CollectionFormView, CollectionListView, JobElementFormView, JobListView, JobModel, JobView, PageView, app, _ref,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

JobModel = require("models/job");

Collection = require("models/collection");

PageView = require("views/page");

CollectionFormView = require("views/collection-form");

CollectionListView = require("views/collection-list");

JobElementFormView = require("views/job-element-form");

JobListView = require("views/job-list");

JobView = require("views/job");

module.exports = Application = (function(_super) {
  __extends(Application, _super);

  function Application() {
    this._validateComponent = __bind(this._validateComponent, this);
    this._addComponent = __bind(this._addComponent, this);
    this._saveJob = __bind(this._saveJob, this);
    this._deleteJob = __bind(this._deleteJob, this);
    this._updateCost = __bind(this._updateCost, this);
    this._readJob = __bind(this._readJob, this);
    this._createJob = __bind(this._createJob, this);
    _ref = Application.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  Application.prototype._jobs = null;

  Application.prototype._current = null;

  Application.prototype._pages = {};

  Application.prototype._steps = {
    type: "add.concrete",
    concrete: "add.labor",
    labor: "add.materials",
    materials: "add.equipment",
    equipment: "add.save"
  };

  Application.prototype.routes = {
    "": "home",
    "home": "home",
    "open": "open",
    "browse": "browse",
    "read.:id": "read",
    "add(.:type)": "add"
  };

  Application.prototype.initialize = function(opts) {
    console.log("Initializing Cole");
    this._jobs = new Collection(null, {
      model: JobModel,
      type: "job",
      url: "jobs"
    });
    this._jobs.fetch();
    this._createJob();
    this._bindEvents();
    return this;
  };

  Application.prototype.home = function() {
    console.log("Loading home page");
    if (this._pages["home"] == null) {
      this._pages["home"] = new PageView({
        id: "home",
        title: "Cole",
        text: {
          id: "start",
          content: ""
        }
      });
      this._setPage(this._pages["home"]);
    }
    return this._showPage(this._pages["home"]);
  };

  Application.prototype.browse = function() {
    console.log("Loading browse page");
    if (!this._pages["browse"]) {
      this._pages["browse"] = new PageView({
        id: "browse",
        title: "Load an Estimate",
        subView: new CollectionListView({
          type: "job",
          collection: this._jobs,
          child: JobListView
        })
      });
      this._setPage(this._pages["browse"]);
    }
    return this._showPage(this._pages["browse"]);
  };

  Application.prototype.read = function(id) {
    console.log("Loading job listing page");
    if (this._pages["read-" + id] == null) {
      this._readJob(id);
      this._pages["read-" + id] = new PageView({
        title: this._current.attributes.name,
        subView: new JobView({
          model: this._current
        })
      });
      this._setPage(this._pages["read-" + id]);
    }
    return this._showPage(this._pages["read-" + id]);
  };

  Application.prototype.add = function(type) {
    var collection, view;
    if (type == null) {
      type = "type";
    }
    console.log("Loading " + type + " component page");
    if (this._pages[type] == null) {
      view = null;
      collection = (function() {
        switch (type) {
          case "concrete":
          case "labor":
          case "materials":
          case "equipment":
            return this._current.get(type);
          default:
            return null;
        }
      }).call(this);
      if (collection != null) {
        console.log("Creating " + type + " collection form view");
        view = new CollectionFormView({
          type: type,
          title: type,
          collection: collection,
          next: this._steps[type]
        });
      } else {
        console.log("Creating job element form view");
        view = (function() {
          switch (type) {
            case "type":
            case "save":
              return new JobElementFormView({
                type: type,
                title: type,
                model: this._current,
                next: this._steps[type]
              });
            default:
              return null;
          }
        }).call(this);
      }
      this._pages[type] = new PageView({
        id: type,
        title: "Job Builder",
        subView: view
      });
      this._addComponent(type);
      this._setPage(this._pages[type]);
    }
    return this._showPage(this._pages[type]);
  };

  Application.prototype._setPage = function(page) {
    $("body").append(page.render().$el);
    return true;
  };

  Application.prototype._showPage = function(page) {
    $("section").hide();
    page.$el.show();
    return true;
  };

  Application.prototype._bindEvents = function() {
    console.log("Binding events");
    $(document).on("tap", "button.btn-primary, button.btn-link, button.job", function(evt) {
      var path;
      evt.preventDefault();
      path = $(evt.currentTarget).data("path");
      return Backbone.history.navigate(path, true);
    });
    $(document).hammer().on("tap", "button.add", this._validateComponent);
    $(document).hammer().on("tap", "button.job.save", this._saveJob);
    $(document).hammer().on("tap", "button.job.reset", this._deleteJob);
    $(document).on("change", "input, select", this._updateCost);
    return true;
  };

  Application.prototype._createJob = function() {
    console.log("Creating new job");
    this._current = new JobModel;
    return this._current;
  };

  Application.prototype._readJob = function(cid) {
    console.log("Reading job " + cid);
    this._current = this._jobs.get(cid);
    return this._current;
  };

  Application.prototype._updateCost = function() {
    var cost;
    console.log("Recalculating job cost");
    if (this._current != null) {
      cost = this._current.calculate();
    }
    $('.job.cost').text(cost);
    return this._current;
  };

  Application.prototype._deleteJob = function() {
    console.log("Deleting job");
    this._current.destroy();
    this._createJob();
    return true;
  };

  Application.prototype._saveJob = function(evt) {
    console.log("Saving job");
    if (this._current.isValid()) {
      this._current.save();
      this._jobs.add(this._current);
      console.log(JSON.stringify(this._current.toJSON()));
      return true;
    } else {
      alert(this._current.validationError);
      return false;
    }
  };

  Application.prototype._addComponent = function(type) {
    switch (type) {
      case "concrete":
      case "labor":
      case "materials":
      case "equipment":
        this._current.get(type).add({});
    }
    return true;
  };

  Application.prototype._validateComponent = function(evt) {
    var last, type;
    evt.preventDefault();
    type = $(evt.currentTarget).data("type");
    console.log("Validating " + type);
    last = this._current.get(type).last();
    if (last.isValid()) {
      console.log("Adding " + type + " to active job");
      this._addComponent(type);
    } else {
      alert(last.validationError);
    }
    return last;
  };

  return Application;

})(Backbone.Router);

module.exports = app = new Application;
});

;require.register("cordova", function(exports, require, module) {
var app;

app = {};

app.initialize = function() {
  this.bindEvents();
  return true;
};

app.bindEvents = function() {
  document.addEventListener('deviceready', this.onDeviceReady, false);
  return true;
};

app.onDeviceReady = function() {
  return app.receivedEvent('deviceready');
};

app.receivedEvent = function(id) {
  var listeningElement, parentElement, receivedElement;
  parentElement = document.getElementById(id);
  listeningElement = parentElement.querySelector('.listening');
  receivedElement = parentElement.querySelector('.received');
  listeningElement.setAttribute('style', 'display:none;');
  receivedElement.setAttribute('style', 'display:block;');
  console.log('Received Event: ' + id);
  return true;
};
});

;require.register("init", function(exports, require, module) {
var app;

app = require("application");

$(function() {
  return Backbone.history.start();
});
});

;require.register("models/base", function(exports, require, module) {
var BaseModel, _ref,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

module.exports = BaseModel = (function(_super) {
  __extends(BaseModel, _super);

  function BaseModel() {
    this.getValue = __bind(this.getValue, this);
    _ref = BaseModel.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  BaseModel.prototype.fields = [];

  BaseModel.prototype.cost = 0;

  BaseModel.prototype.check = {
    number: function(value, label) {
      var result;
      result = false;
      if (value == null) {
        result = "You must enter a " + label;
      }
      if (value === "") {
        result = "You must enter a " + label;
      }
      if (isNaN(value)) {
        result = "" + label + " must be a number";
      }
      if (isNaN(parseInt(value))) {
        result = "" + label + " must be a number";
      }
      if (value < 1) {
        result = "" + label + " must be at least 1";
      }
      return result;
    },
    text: function(value, label) {
      var result;
      result = false;
      if (value == null) {
        result = "You must enter a " + label;
      }
      if (value === "") {
        result = "You must enter a " + label;
      }
      return result;
    },
    select: function(value, label) {
      var result;
      result = false;
      if (value == null) {
        result = "You must select a " + label;
      }
      if (value === "") {
        result = "You must select a " + label;
      }
      if (value < 1) {
        result = "You must select a " + label;
      }
      return result;
    }
  };

  BaseModel.prototype.validate = function(attrs, opts) {
    var fail, field, _fn, _i, _len, _ref1,
      _this = this;
    fail = false;
    _ref1 = this.fields;
    _fn = function(field) {
      if (!fail) {
        fail = (function() {
          switch (field.type) {
            case "number":
            case "text":
            case "select":
              return this.check[field.type](attrs[field.name], field.name);
            default:
              return false;
          }
        }).call(_this);
      }
      return null;
    };
    for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
      field = _ref1[_i];
      _fn(field);
    }
    if (!fail) {
      fail = "";
    }
    return fail;
  };

  BaseModel.prototype.getFields = function(showAll) {
    var field, fields, _i, _len;
    if (showAll == null) {
      showAll = false;
    }
    fields = showAll ? this.fields : _.where(this.fields, {
      show: true
    });
    for (_i = 0, _len = fields.length; _i < _len; _i++) {
      field = fields[_i];
      field.value = this.getValue(field);
    }
    return fields;
  };

  BaseModel.prototype.getValue = function(field) {
    var type, value, _i, _len, _ref1;
    value = this.attributes[field.name];
    console.log("Field is " + field.name + " with value of " + value);
    if (field.name === "type" && (this.types != null)) {
      _ref1 = this.types;
      for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
        type = _ref1[_i];
        value = this._setValue(type, value);
      }
    }
    return value;
  };

  BaseModel.prototype._setValue = function(type, value) {
    value = parseInt(type.id) === parseInt(value) ? type.name : value;
    return value;
  };

  return BaseModel;

})(Backbone.Model);
});

;require.register("models/collection", function(exports, require, module) {
var Collection, _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

module.exports = Collection = (function(_super) {
  __extends(Collection, _super);

  function Collection() {
    _ref = Collection.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  Collection.prototype.initialize = function(models, opts) {
    this.cost = 0;
    this.type = opts.type;
    if (opts.url != null) {
      this.url = opts.url;
    }
    this.localStorage = new Backbone.LocalStorage("cole-" + this.type);
    return null;
  };

  Collection.prototype.calculate = function() {
    var row, _i, _len, _ref1;
    this.cost = 0;
    _ref1 = this.models;
    for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
      row = _ref1[_i];
      this.cost += row.calculate();
    }
    console.log("" + this.type + " total", this.cost);
    return this.cost;
  };

  return Collection;

})(Backbone.Collection);
});

;require.register("models/concrete", function(exports, require, module) {
var ConcreteModel, Model, _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Model = require("models/base");

module.exports = ConcreteModel = (function(_super) {
  __extends(ConcreteModel, _super);

  function ConcreteModel() {
    _ref = ConcreteModel.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  ConcreteModel.prototype.defaults = {
    "quantity": null,
    "depth": null,
    "width": null,
    "length": null,
    "price": null,
    "tax": null
  };

  ConcreteModel.prototype.fields = [
    {
      text: "Quantity",
      name: "quantity",
      type: "number",
      show: true
    }, {
      text: "Depth",
      name: "depth",
      type: "number",
      show: true
    }, {
      text: "Width",
      name: "width",
      type: "number",
      show: true
    }, {
      text: "Length",
      name: "length",
      type: "number",
      show: true
    }, {
      text: "Price",
      name: "price",
      type: "number",
      show: true
    }, {
      text: "Tax rate",
      name: "tax",
      type: "number",
      show: true
    }
  ];

  ConcreteModel.prototype.calculate = function() {
    this.cost = this.attributes.depth * this.attributes.width * this.attributes.length * this.attributes.quantity * this.attributes.price;
    console.log("concrete: " + this.attributes.depth + "d x " + this.attributes.width + "w x " + this.attributes.length + "h x " + this.attributes.quantity + " @ $" + this.attributes.price + " = " + this.cost);
    return this.cost;
  };

  return ConcreteModel;

})(Model);
});

;require.register("models/equipment", function(exports, require, module) {
var EquipmentModel, Model, _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Model = require("models/base");

module.exports = EquipmentModel = (function(_super) {
  __extends(EquipmentModel, _super);

  function EquipmentModel() {
    _ref = EquipmentModel.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  EquipmentModel.prototype.defaults = {
    "type": 1,
    "quantity": null,
    "rate": null
  };

  EquipmentModel.prototype.types = [
    {
      id: "1",
      name: "Dump Truck"
    }, {
      id: "2",
      name: "Excavator"
    }, {
      id: "3",
      name: "Bobcat"
    }, {
      id: "4",
      name: "C pump"
    }, {
      id: "5",
      name: "Piles"
    }, {
      id: "6",
      name: "Trial"
    }, {
      id: "7",
      name: "Util Truck"
    }
  ];

  EquipmentModel.prototype.fields = [
    {
      type: "number",
      text: "Quantity",
      name: "quantity",
      show: true
    }, {
      type: "number",
      text: "Rate",
      name: "rate",
      show: true
    }, {
      type: "select",
      text: "Type",
      name: "type",
      show: false
    }
  ];

  EquipmentModel.prototype.calculate = function() {
    this.cost = this.attributes.quantity * this.attributes.rate;
    console.log("equipment row #" + this.cid + ": " + this.attributes.quantity + "@$" + this.attributes.rate + " = " + this.cost);
    return this.cost;
  };

  return EquipmentModel;

})(Model);
});

;require.register("models/job", function(exports, require, module) {
var BaseModel, Collection, ConcreteModel, EquipmentModel, JobModel, LaborModel, MaterialModel, _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

BaseModel = require("models/base");

LaborModel = require("models/labor");

ConcreteModel = require("models/concrete");

MaterialModel = require("models/material");

EquipmentModel = require("models/equipment");

Collection = require("models/collection");

module.exports = JobModel = (function(_super) {
  __extends(JobModel, _super);

  function JobModel() {
    _ref = JobModel.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  JobModel.prototype.localStorage = new Backbone.LocalStorage("cole-job");

  JobModel.prototype.url = "jobs";

  JobModel.prototype.types = [
    {
      id: "1",
      name: "Slab"
    }, {
      id: "2",
      name: "GB- H"
    }, {
      id: "3",
      name: "GB - H1A"
    }, {
      id: "4",
      name: "GB - V"
    }, {
      id: "5",
      name: "Piles"
    }, {
      id: "6",
      name: "Truck Well"
    }
  ];

  JobModel.prototype.fields = [
    {
      text: "Job Name",
      name: "name",
      type: "text",
      show: false
    }, {
      text: "Type",
      name: "type",
      type: "select",
      show: true
    }, {
      text: "Profit Margin",
      name: "margin",
      type: "number",
      show: true
    }
  ];

  JobModel.prototype.defaults = function() {
    var data;
    data = {
      name: null,
      margin: null,
      type: 1,
      dirt: null
    };
    return this.parse(data);
  };

  JobModel.prototype.parse = function(data) {
    var collection, collections, saved, _i, _len;
    collections = ["concrete", "labor", "materials", "equipment"];
    for (_i = 0, _len = collections.length; _i < _len; _i++) {
      collection = collections[_i];
      saved = data[collection] != null ? data[collection] : false;
      data[collection] = this._inflateCollection(collection, saved);
    }
    return data;
  };

  JobModel.prototype._inflateCollection = function(type, data) {
    var model;
    model = (function() {
      switch (type) {
        case "concrete":
          return ConcreteModel;
        case "labor":
          return LaborModel;
        case "materials":
          return MaterialModel;
        case "equipment":
          return EquipmentModel;
      }
    })();
    return new Collection(data, {
      model: model,
      type: type
    });
  };

  JobModel.prototype.calculate = function() {
    this.cost = this.attributes.concrete.calculate() + this.attributes.labor.calculate() + this.attributes.materials.calculate() + this.attributes.equipment.calculate();
    if (this.cost) {
      console.log("Job total: " + this.attributes.equipment.cost + " + " + this.attributes.concrete.cost + " + " + this.attributes.labor.cost + " + " + this.attributes.materials.cost + " = " + this.cost);
    }
    return this.cost;
  };

  return JobModel;

})(BaseModel);
});

;require.register("models/labor", function(exports, require, module) {
var LaborModel, Model, _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Model = require("models/base");

module.exports = LaborModel = (function(_super) {
  __extends(LaborModel, _super);

  function LaborModel() {
    _ref = LaborModel.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  LaborModel.prototype.defaults = {
    "type": 1,
    "number": null,
    "unit": null,
    "rate": null
  };

  LaborModel.prototype.types = [
    {
      id: "1",
      name: "Finishers"
    }, {
      id: "2",
      name: "Supervisors"
    }, {
      id: "3",
      name: "Forms crp"
    }, {
      id: "4",
      name: "Laborers"
    }, {
      id: "5",
      name: "Driver"
    }, {
      id: "6",
      name: "Operator"
    }
  ];

  LaborModel.prototype.fields = [
    {
      type: "number",
      text: "Number",
      name: "number",
      show: true
    }, {
      type: "number",
      text: "Unit",
      name: "unit",
      show: true
    }, {
      type: "number",
      text: "Rate",
      name: "rate",
      show: true
    }, {
      type: "select",
      text: "Type",
      name: "type",
      show: false
    }
  ];

  LaborModel.prototype.calculate = function() {
    this.cost = this.attributes.number * this.attributes.rate * this.attributes.unit;
    console.log("labor row #" + this.cid + ": " + this.attributes.number + " x " + this.attributes.unit + "u @ $" + this.attributes.rate + " = " + this.cost);
    return this.cost;
  };

  return LaborModel;

})(Model);
});

;require.register("models/material", function(exports, require, module) {
var MaterialModel, Model, _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Model = require("models/base");

module.exports = MaterialModel = (function(_super) {
  __extends(MaterialModel, _super);

  function MaterialModel() {
    _ref = MaterialModel.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  MaterialModel.prototype.defaults = {
    "quantity": null,
    "price": null,
    "type": 1
  };

  MaterialModel.prototype.types = [
    {
      id: "1",
      name: "Wire (sheet)"
    }, {
      id: "2",
      name: "Keyway (lf)"
    }, {
      id: "3",
      name: "Stakes (ea.)"
    }, {
      id: "4",
      name: "Cap (lf)"
    }, {
      id: "5",
      name: "Dowells  (ea.)"
    }, {
      id: "6",
      name: "2x8x20  (lf)"
    }, {
      id: "7",
      name: "Misc"
    }
  ];

  MaterialModel.prototype.fields = [
    {
      text: "Quantity",
      name: "quantity",
      type: "number",
      show: true
    }, {
      text: "Price",
      name: "price",
      type: "number",
      show: true
    }, {
      text: "Type",
      name: "type",
      type: "select",
      show: false
    }
  ];

  MaterialModel.prototype.calculate = function() {
    this.cost = this.attributes.quantity * this.attributes.price;
    console.log("material row #" + this.cid + ": " + this.attributes.quantity + "@" + this.attributes.price + " = " + this.cost);
    return this.cost;
  };

  return MaterialModel;

})(Model);
});

;require.register("templates/collection.form", function(exports, require, module) {
var __templateData = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, functionType="function", escapeExpression=this.escapeExpression, self=this;

function program1(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n    <button class=\"";
  if (stack1 = helpers.type) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = (depth0 && depth0.type); stack1 = typeof stack1 === functionType ? stack1.call(depth0, {hash:{},data:data}) : stack1; }
  buffer += escapeExpression(stack1)
    + " add btn btn-default\" data-type=\"";
  if (stack1 = helpers.type) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = (depth0 && depth0.type); stack1 = typeof stack1 === functionType ? stack1.call(depth0, {hash:{},data:data}) : stack1; }
  buffer += escapeExpression(stack1)
    + "\">Add another</button>\n";
  return buffer;
  }

function program3(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n    <button class=\"";
  if (stack1 = helpers.type) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = (depth0 && depth0.type); stack1 = typeof stack1 === functionType ? stack1.call(depth0, {hash:{},data:data}) : stack1; }
  buffer += escapeExpression(stack1)
    + " btn btn-primary next\" data-path=\"";
  if (stack1 = helpers.next) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = (depth0 && depth0.next); stack1 = typeof stack1 === functionType ? stack1.call(depth0, {hash:{},data:data}) : stack1; }
  buffer += escapeExpression(stack1)
    + "\">Next</button>\n";
  return buffer;
  }

  buffer += "<h3>";
  if (stack1 = helpers.title) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = (depth0 && depth0.title); stack1 = typeof stack1 === functionType ? stack1.call(depth0, {hash:{},data:data}) : stack1; }
  buffer += escapeExpression(stack1)
    + "</h3>\n\n<div class=\"";
  if (stack1 = helpers.type) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = (depth0 && depth0.type); stack1 = typeof stack1 === functionType ? stack1.call(depth0, {hash:{},data:data}) : stack1; }
  buffer += escapeExpression(stack1)
    + " items\"></div>\n<div class=\"text-info pull-right\">\n    Cost: $<span class=\"";
  if (stack1 = helpers.type) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = (depth0 && depth0.type); stack1 = typeof stack1 === functionType ? stack1.call(depth0, {hash:{},data:data}) : stack1; }
  buffer += escapeExpression(stack1)
    + " cost\">0</span>\n</div>\n\n";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.multiple), {hash:{},inverse:self.noop,fn:self.program(1, program1, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n\n";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.next), {hash:{},inverse:self.noop,fn:self.program(3, program3, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n";
  return buffer;
  });
if (typeof define === 'function' && define.amd) {
  define([], function() {
    return __templateData;
  });
} else if (typeof module === 'object' && module && module.exports) {
  module.exports = __templateData;
} else {
  __templateData;
}
});

;require.register("templates/collection.list", function(exports, require, module) {
var __templateData = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, functionType="function", escapeExpression=this.escapeExpression, self=this;

function program1(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n    <div class=\"peanl-heading\">\n        <h4 class=\"panel-title\">";
  if (stack1 = helpers.title) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = (depth0 && depth0.title); stack1 = typeof stack1 === functionType ? stack1.call(depth0, {hash:{},data:data}) : stack1; }
  buffer += escapeExpression(stack1)
    + "</h4>\n    </div>\n";
  return buffer;
  }

  stack1 = helpers['if'].call(depth0, (depth0 && depth0.title), {hash:{},inverse:self.noop,fn:self.program(1, program1, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n<div class=\"panel-body\">\n    <div class=\"";
  if (stack1 = helpers.type) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = (depth0 && depth0.type); stack1 = typeof stack1 === functionType ? stack1.call(depth0, {hash:{},data:data}) : stack1; }
  buffer += escapeExpression(stack1)
    + " text-success\">\n        Cost: $<span class=\"";
  if (stack1 = helpers.type) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = (depth0 && depth0.type); stack1 = typeof stack1 === functionType ? stack1.call(depth0, {hash:{},data:data}) : stack1; }
  buffer += escapeExpression(stack1)
    + " cost\">";
  if (stack1 = helpers.cost) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = (depth0 && depth0.cost); stack1 = typeof stack1 === functionType ? stack1.call(depth0, {hash:{},data:data}) : stack1; }
  buffer += escapeExpression(stack1)
    + "</span>\n    </div>\n    <ul class=\"";
  if (stack1 = helpers.type) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = (depth0 && depth0.type); stack1 = typeof stack1 === functionType ? stack1.call(depth0, {hash:{},data:data}) : stack1; }
  buffer += escapeExpression(stack1)
    + " items list-group\"></ul>\n</div>\n";
  return buffer;
  });
if (typeof define === 'function' && define.amd) {
  define([], function() {
    return __templateData;
  });
} else if (typeof module === 'object' && module && module.exports) {
  module.exports = __templateData;
} else {
  __templateData;
}
});

;require.register("templates/component.form", function(exports, require, module) {
var __templateData = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, functionType="function", escapeExpression=this.escapeExpression, self=this;

function program1(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n<fieldset class=\"form-group\">\n    <select id=\"";
  if (stack1 = helpers.type) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = (depth0 && depth0.type); stack1 = typeof stack1 === functionType ? stack1.call(depth0, {hash:{},data:data}) : stack1; }
  buffer += escapeExpression(stack1)
    + "_type_";
  if (stack1 = helpers.cid) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = (depth0 && depth0.cid); stack1 = typeof stack1 === functionType ? stack1.call(depth0, {hash:{},data:data}) : stack1; }
  buffer += escapeExpression(stack1)
    + "\" name=\"type\" class=\"field ";
  if (stack1 = helpers.type) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = (depth0 && depth0.type); stack1 = typeof stack1 === functionType ? stack1.call(depth0, {hash:{},data:data}) : stack1; }
  buffer += escapeExpression(stack1)
    + " type form-control\">\n        ";
  stack1 = helpers.each.call(depth0, (depth0 && depth0.types), {hash:{},inverse:self.noop,fn:self.program(2, program2, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n    </select>\n</fieldset>\n";
  return buffer;
  }
function program2(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n            <option value=\"";
  if (stack1 = helpers.id) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = (depth0 && depth0.id); stack1 = typeof stack1 === functionType ? stack1.call(depth0, {hash:{},data:data}) : stack1; }
  buffer += escapeExpression(stack1)
    + "\">";
  if (stack1 = helpers.name) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = (depth0 && depth0.name); stack1 = typeof stack1 === functionType ? stack1.call(depth0, {hash:{},data:data}) : stack1; }
  buffer += escapeExpression(stack1)
    + "</option>\n        ";
  return buffer;
  }

function program4(depth0,data,depth1) {
  
  var buffer = "", stack1;
  buffer += "\n        <input type=\""
    + escapeExpression(((stack1 = (depth0 && depth0.type)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\" placeholder=\""
    + escapeExpression(((stack1 = (depth0 && depth0.text)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\" id=\""
    + escapeExpression(((stack1 = (depth1 && depth1.type)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "-"
    + escapeExpression(((stack1 = (depth0 && depth0.name)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "-"
    + escapeExpression(((stack1 = (depth1 && depth1.cid)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\" name=\""
    + escapeExpression(((stack1 = (depth0 && depth0.name)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\" value=\""
    + escapeExpression(((stack1 = (depth0 && depth0.value)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\" class=\"field "
    + escapeExpression(((stack1 = (depth1 && depth1.type)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + " "
    + escapeExpression(((stack1 = (depth0 && depth0.name)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + " form-control\"></input>\n    ";
  return buffer;
  }

  stack1 = helpers['if'].call(depth0, (depth0 && depth0.types), {hash:{},inverse:self.noop,fn:self.program(1, program1, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n<fieldset class=\"form-group\">\n    ";
  stack1 = helpers.each.call(depth0, (depth0 && depth0.fields), {hash:{},inverse:self.noop,fn:self.programWithDepth(4, program4, data, depth0),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n</fieldset>\n";
  return buffer;
  });
if (typeof define === 'function' && define.amd) {
  define([], function() {
    return __templateData;
  });
} else if (typeof module === 'object' && module && module.exports) {
  module.exports = __templateData;
} else {
  __templateData;
}
});

;require.register("templates/component.list", function(exports, require, module) {
var __templateData = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, functionType="function", escapeExpression=this.escapeExpression, self=this;

function program1(depth0,data,depth1) {
  
  var buffer = "", stack1;
  buffer += "\n    <div class=\"field "
    + escapeExpression(((stack1 = (depth1 && depth1.type)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + " "
    + escapeExpression(((stack1 = (depth0 && depth0.name)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\">"
    + escapeExpression(((stack1 = (depth0 && depth0.text)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + ": "
    + escapeExpression(((stack1 = (depth0 && depth0.value)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "</div>\n";
  return buffer;
  }

  stack1 = helpers.each.call(depth0, (depth0 && depth0.fields), {hash:{},inverse:self.noop,fn:self.programWithDepth(1, program1, data, depth0),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n<div class=\"";
  if (stack1 = helpers.type) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = (depth0 && depth0.type); stack1 = typeof stack1 === functionType ? stack1.call(depth0, {hash:{},data:data}) : stack1; }
  buffer += escapeExpression(stack1)
    + " text-info\">\n    Cost: $<span class=\"";
  if (stack1 = helpers.type) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = (depth0 && depth0.type); stack1 = typeof stack1 === functionType ? stack1.call(depth0, {hash:{},data:data}) : stack1; }
  buffer += escapeExpression(stack1)
    + " cost\">";
  if (stack1 = helpers.cost) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = (depth0 && depth0.cost); stack1 = typeof stack1 === functionType ? stack1.call(depth0, {hash:{},data:data}) : stack1; }
  buffer += escapeExpression(stack1)
    + "</span>\n</div>\n";
  return buffer;
  });
if (typeof define === 'function' && define.amd) {
  define([], function() {
    return __templateData;
  });
} else if (typeof module === 'object' && module && module.exports) {
  module.exports = __templateData;
} else {
  __templateData;
}
});

;require.register("templates/header", function(exports, require, module) {
var __templateData = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, functionType="function", escapeExpression=this.escapeExpression;


  buffer += "<nav class=\"col-xs-12 navbar navbar-default\" role=\"navigation\">\n    <ul class=\"nav nav-pills\">\n        <li>\n            <a href=\"#home\" class=\"navbar-btn\"><i class=\"fa fa-home\"></i> Home</a>\n        </li>\n        <li>\n            <a href=\"#add\" class=\"navbar-btn\"><i class=\"fa fa-plus-square-o\"></i> New</a>\n        </li>\n        <li>\n            <a href=\"#browse\" class=\"navbar-btn\"><i class=\"fa fa-folder-open-o\"></i> Load</a>\n        </li>\n    </ul>\n</nav>\n<div class=\"page-header\">\n  <h1>";
  if (stack1 = helpers.title) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = (depth0 && depth0.title); stack1 = typeof stack1 === functionType ? stack1.call(depth0, {hash:{},data:data}) : stack1; }
  buffer += escapeExpression(stack1)
    + "</h1>\n</div>\n";
  return buffer;
  });
if (typeof define === 'function' && define.amd) {
  define([], function() {
    return __templateData;
  });
} else if (typeof module === 'object' && module && module.exports) {
  module.exports = __templateData;
} else {
  __templateData;
}
});

;require.register("templates/job", function(exports, require, module) {
var __templateData = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, stack2, functionType="function", escapeExpression=this.escapeExpression, self=this;

function program1(depth0,data,depth1) {
  
  var buffer = "", stack1;
  buffer += "\n    <div class=\"field "
    + escapeExpression(((stack1 = (depth1 && depth1.type)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + " "
    + escapeExpression(((stack1 = (depth0 && depth0.name)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\">"
    + escapeExpression(((stack1 = (depth0 && depth0.text)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + ": "
    + escapeExpression(((stack1 = (depth0 && depth0.value)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "</div>\n";
  return buffer;
  }

  buffer += "<h2>"
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.row)),stack1 == null || stack1 === false ? stack1 : stack1.title)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "</h2>\n\n";
  stack2 = helpers.each.call(depth0, (depth0 && depth0.row), {hash:{},inverse:self.noop,fn:self.programWithDepth(1, program1, data, depth0),data:data});
  if(stack2 || stack2 === 0) { buffer += stack2; }
  buffer += "\n\n<div class=\"";
  if (stack2 = helpers.type) { stack2 = stack2.call(depth0, {hash:{},data:data}); }
  else { stack2 = (depth0 && depth0.type); stack2 = typeof stack2 === functionType ? stack2.call(depth0, {hash:{},data:data}) : stack2; }
  buffer += escapeExpression(stack2)
    + " text-success\">\n    Cost: $<span class=\"";
  if (stack2 = helpers.type) { stack2 = stack2.call(depth0, {hash:{},data:data}); }
  else { stack2 = (depth0 && depth0.type); stack2 = typeof stack2 === functionType ? stack2.call(depth0, {hash:{},data:data}) : stack2; }
  buffer += escapeExpression(stack2)
    + " cost\">";
  if (stack2 = helpers.cost) { stack2 = stack2.call(depth0, {hash:{},data:data}); }
  else { stack2 = (depth0 && depth0.cost); stack2 = typeof stack2 === functionType ? stack2.call(depth0, {hash:{},data:data}) : stack2; }
  buffer += escapeExpression(stack2)
    + "</span>\n</div>\n\n<div class=\"job items\"></div>\n\n";
  return buffer;
  });
if (typeof define === 'function' && define.amd) {
  define([], function() {
    return __templateData;
  });
} else if (typeof module === 'object' && module && module.exports) {
  module.exports = __templateData;
} else {
  __templateData;
}
});

;require.register("templates/job.list", function(exports, require, module) {
var __templateData = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, stack2, functionType="function", escapeExpression=this.escapeExpression;


  buffer += "<a class=\"job list-group-item\" href=\"#read.";
  if (stack1 = helpers.cid) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = (depth0 && depth0.cid); stack1 = typeof stack1 === functionType ? stack1.call(depth0, {hash:{},data:data}) : stack1; }
  buffer += escapeExpression(stack1)
    + "\">\n    <h4 class=\"job list-group-item-heading\">"
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.row)),stack1 == null || stack1 === false ? stack1 : stack1.name)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "</h4>\n    <div class=\"job list-group-item-text text-info\">\n        Cost: $<span class=\"job cost\">";
  if (stack2 = helpers.cost) { stack2 = stack2.call(depth0, {hash:{},data:data}); }
  else { stack2 = (depth0 && depth0.cost); stack2 = typeof stack2 === functionType ? stack2.call(depth0, {hash:{},data:data}) : stack2; }
  buffer += escapeExpression(stack2)
    + "</span>\n    </div>\n</a>\n";
  return buffer;
  });
if (typeof define === 'function' && define.amd) {
  define([], function() {
    return __templateData;
  });
} else if (typeof module === 'object' && module && module.exports) {
  module.exports = __templateData;
} else {
  __templateData;
}
});

;require.register("templates/page", function(exports, require, module) {
var __templateData = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, functionType="function", escapeExpression=this.escapeExpression;


  buffer += "<article id=\""
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.text)),stack1 == null || stack1 === false ? stack1 : stack1.id)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\" class=\"col-xs-12\">"
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.text)),stack1 == null || stack1 === false ? stack1 : stack1.content)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "</article>\n";
  return buffer;
  });
if (typeof define === 'function' && define.amd) {
  define([], function() {
    return __templateData;
  });
} else if (typeof module === 'object' && module && module.exports) {
  module.exports = __templateData;
} else {
  __templateData;
}
});

;require.register("templates/save.form", function(exports, require, module) {
var __templateData = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, stack2, functionType="function", escapeExpression=this.escapeExpression;


  buffer += "<fieldset class=\"form-group\">\n    <input type=\"number\" placeholder=\"Profit Margin\" id=\"job-profit-margin\" name=\"margin\" class=\"job field form-control\" value=\""
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.row)),stack1 == null || stack1 === false ? stack1 : stack1.margin)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\" />\n     <input type=\"text\" placeholder=\"Job Name\" id=\"job-name\" name=\"name\" class=\"job field form-control\" value=\""
    + escapeExpression(((stack1 = ((stack1 = (depth0 && depth0.row)),stack1 == null || stack1 === false ? stack1 : stack1.name)),typeof stack1 === functionType ? stack1.apply(depth0) : stack1))
    + "\" />\n</fieldset>\n<div class=\"job text-success pull-right\">\n    Total Cost:\n    <span class=\"job cost\">";
  if (stack2 = helpers.cost) { stack2 = stack2.call(depth0, {hash:{},data:data}); }
  else { stack2 = (depth0 && depth0.cost); stack2 = typeof stack2 === functionType ? stack2.call(depth0, {hash:{},data:data}) : stack2; }
  buffer += escapeExpression(stack2)
    + "</span>\n</div>\n<button class=\"btn btn-success btn-block job save\" data-path=\"home\">Save</button>\n<button class=\"btn btn-danger btn-block job reset\" data-path=\"create\">Start Over</button>\n";
  return buffer;
  });
if (typeof define === 'function' && define.amd) {
  define([], function() {
    return __templateData;
  });
} else if (typeof module === 'object' && module && module.exports) {
  module.exports = __templateData;
} else {
  __templateData;
}
});

;require.register("templates/type.form", function(exports, require, module) {
var __templateData = Handlebars.template(function (Handlebars,depth0,helpers,partials,data) {
  this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Handlebars.helpers); data = data || {};
  var buffer = "", stack1, functionType="function", escapeExpression=this.escapeExpression, self=this;

function program1(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n            <option value=\"";
  if (stack1 = helpers.id) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = (depth0 && depth0.id); stack1 = typeof stack1 === functionType ? stack1.call(depth0, {hash:{},data:data}) : stack1; }
  buffer += escapeExpression(stack1)
    + "\">";
  if (stack1 = helpers.name) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = (depth0 && depth0.name); stack1 = typeof stack1 === functionType ? stack1.call(depth0, {hash:{},data:data}) : stack1; }
  buffer += escapeExpression(stack1)
    + "</option>\n        ";
  return buffer;
  }

function program3(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n    <button class=\"btn btn-primary next\" data-path=\"";
  if (stack1 = helpers.next) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = (depth0 && depth0.next); stack1 = typeof stack1 === functionType ? stack1.call(depth0, {hash:{},data:data}) : stack1; }
  buffer += escapeExpression(stack1)
    + "\">Next</a>\n";
  return buffer;
  }

  buffer += "<h4>";
  if (stack1 = helpers.title) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = (depth0 && depth0.title); stack1 = typeof stack1 === functionType ? stack1.call(depth0, {hash:{},data:data}) : stack1; }
  buffer += escapeExpression(stack1)
    + "</h4>\n\n<fieldset class=\"form-group\">\n    <label for=\"job_type_";
  if (stack1 = helpers.cid) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = (depth0 && depth0.cid); stack1 = typeof stack1 === functionType ? stack1.call(depth0, {hash:{},data:data}) : stack1; }
  buffer += escapeExpression(stack1)
    + "\">Select a job type</label>\n    <select id=\"job_type_";
  if (stack1 = helpers.cid) { stack1 = stack1.call(depth0, {hash:{},data:data}); }
  else { stack1 = (depth0 && depth0.cid); stack1 = typeof stack1 === functionType ? stack1.call(depth0, {hash:{},data:data}) : stack1; }
  buffer += escapeExpression(stack1)
    + "\" name=\"type\" class=\"field job type form-control\">\n        ";
  stack1 = helpers.each.call(depth0, (depth0 && depth0.types), {hash:{},inverse:self.noop,fn:self.program(1, program1, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n    </select>\n</fieldset>\n\n";
  stack1 = helpers['if'].call(depth0, (depth0 && depth0.next), {hash:{},inverse:self.noop,fn:self.program(3, program3, data),data:data});
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n";
  return buffer;
  });
if (typeof define === 'function' && define.amd) {
  define([], function() {
    return __templateData;
  });
} else if (typeof module === 'object' && module && module.exports) {
  module.exports = __templateData;
} else {
  __templateData;
}
});

;require.register("views/base", function(exports, require, module) {
var BaseView, _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

module.exports = BaseView = (function(_super) {
  __extends(BaseView, _super);

  function BaseView() {
    _ref = BaseView.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  BaseView.prototype.type = "component";

  BaseView.prototype.self = null;

  BaseView.prototype.container = null;

  BaseView.prototype.templateFile = null;

  BaseView.prototype._child = null;

  BaseView.prototype.initialize = function() {
    if (this.self == null) {
      this.self = this.constructor;
    }
    if (this.container == null) {
      this.container = "." + this.type + "-items";
    }
    if (this.templateFile == null) {
      this.templateFile = "templates/create/" + this.type;
    }
    this.template = require(this.templateFile);
    return null;
  };

  BaseView.prototype.render = function() {
    this.$el.html(this.template);
    console.log("Rendering " + this.type + " into " + this.container);
    $(this.container).append(this.$el);
    return this;
  };

  BaseView.prototype.setName = function() {
    this.$el.remove();
    delete this.el;
    this._ensureElement();
    return null;
  };

  return BaseView;

})(Backbone.View);
});

;require.register("views/collection-form", function(exports, require, module) {
var CollectionFormView, CollectionView, ComponentFormView, _ref,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

CollectionView = require("views/collection");

ComponentFormView = require("views/component-form");

module.exports = CollectionFormView = (function(_super) {
  __extends(CollectionFormView, _super);

  function CollectionFormView() {
    this.render = __bind(this.render, this);
    _ref = CollectionFormView.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  CollectionFormView.prototype.tagName = "article";

  CollectionFormView.prototype.initialize = function(opts) {
    this.child = ComponentFormView;
    CollectionFormView.__super__.initialize.call(this, opts);
    this.id = "job-form-" + this.type;
    this.className = "" + this.type + "-form-collection col-xs-12";
    this.multiple = (function() {
      switch (this.type) {
        case "type":
        case "job":
        case "concrete":
          return false;
        default:
          return true;
      }
    }).call(this);
    if (opts.next != null) {
      this.next = opts.next;
    }
    if (opts.title != null) {
      this.title = opts.title;
    }
    this.setName();
    this.template = require("templates/collection.form");
    return null;
  };

  CollectionFormView.prototype.render = function() {
    var _this = this;
    console.log("Rendering " + this.type + " collection");
    this._rendered = true;
    this.$el.empty();
    this.$el.html(this.template({
      type: this.type,
      next: this.next,
      title: this.title,
      multiple: this.multiple
    }));
    _(this._children).each(function(child) {
      return _this.$(".items").append(child.render().$el);
    });
    return this;
  };

  return CollectionFormView;

})(CollectionView);
});

;require.register("views/collection-list", function(exports, require, module) {
var CollectionListView, CollectionView, ComponentListView, _ref,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

CollectionView = require("views/collection");

ComponentListView = require("views/component-list");

module.exports = CollectionListView = (function(_super) {
  __extends(CollectionListView, _super);

  function CollectionListView() {
    this.render = __bind(this.render, this);
    _ref = CollectionListView.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  CollectionListView.prototype.initialize = function(opts) {
    this.child = ComponentListView;
    CollectionListView.__super__.initialize.call(this, opts);
    if (!this.id) {
      this.id = "job-list-" + this.type;
    }
    if (!this.className) {
      this.className = "" + this.type + "-list-collection";
    }
    if (opts.next != null) {
      this.next = opts.next;
    }
    if (opts.title != null) {
      this.title = opts.title;
    }
    this.setName();
    this.template = require("templates/collection.list");
    return null;
  };

  CollectionListView.prototype.render = function() {
    var _this = this;
    console.log("Rendering " + this.type + " list collection");
    this._rendered = true;
    this.$el.empty();
    this.$el.html(this.template({
      type: this.type,
      title: this.title,
      cost: this.collection.calculate != null ? this.collection.calculate() : void 0
    }));
    _(this._children).each(function(child) {
      return _this.$(".items").append(child.render().$el);
    });
    return this;
  };

  return CollectionListView;

})(CollectionView);
});

;require.register("views/collection", function(exports, require, module) {
var BaseView, CollectionView, ComponentView, _ref,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

BaseView = require("views/base");

ComponentView = require("views/component");

module.exports = CollectionView = (function(_super) {
  __extends(CollectionView, _super);

  function CollectionView() {
    this.add = __bind(this.add, this);
    _ref = CollectionView.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  CollectionView.prototype.initialize = function(opts) {
    this.type = opts.type != null ? opts.type : "collection";
    if (this.className == null) {
      this.className = "" + this.type + "-collection";
    }
    if (opts.child != null) {
      this.child = opts.child;
    }
    this.child = this.child != null ? this.child : ComponentView;
    this._children = [];
    this._rendered = false;
    this.setName();
    this.collection.each(this.add);
    _(this).bindAll('add', 'remove');
    this.listenTo(this.collection, 'add', this.add);
    this.listenTo(this.collection, 'remove', this.remove);
    return null;
  };

  CollectionView.prototype.render = function() {
    var _this = this;
    console.log("Rendering " + this.type + " collection");
    this._rendered = true;
    this.$el.empty();
    _(this._children).each(function(child) {
      return _this.$(".items").append(child.render().$el);
    });
    return this;
  };

  CollectionView.prototype.add = function(model) {
    var child;
    child = new this.child({
      model: model,
      type: this.type
    });
    this._children.push(child);
    if (this._rendered) {
      this.$(".items").append(child.render().$el);
    }
    return null;
  };

  CollectionView.prototype.remove = function(model) {
    var orphan;
    orphan = _(this._children).select(function(child) {
      return child.model === model;
    });
    orphan = orpan.unshift();
    orphan.stopListening();
    this._children = _(this._children).without(orphan);
    if (this._rendered) {
      orphan.$el.remove();
    }
    return null;
  };

  return CollectionView;

})(BaseView);
});

;require.register("views/component-form", function(exports, require, module) {
var ComponentFormView, ComponentView, _ref,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

ComponentView = require("views/component");

module.exports = ComponentFormView = (function(_super) {
  __extends(ComponentFormView, _super);

  function ComponentFormView() {
    this.refresh = __bind(this.refresh, this);
    _ref = ComponentFormView.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  ComponentFormView.prototype.events = {
    "change .field": "refresh"
  };

  ComponentFormView.prototype.initialize = function(opts) {
    ComponentFormView.__super__.initialize.call(this, opts);
    this.template = require("templates/component.form");
    this.className = "" + this.type + " " + this.type + "-form " + this.type + "-form-item";
    this.setName();
    _.bindAll(this, "refresh");
    return null;
  };

  ComponentFormView.prototype.refresh = function(event) {
    var target;
    target = $(event.currentTarget);
    this.model.set(target.attr('name'), target.val());
    console.log("View changed", target.attr('name'), target.val());
    $("." + this.type + ".cost").text(this.model.collection.calculate());
    return null;
  };

  return ComponentFormView;

})(ComponentView);
});

;require.register("views/component-list", function(exports, require, module) {
var ComponentListView, ComponentView, _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

ComponentView = require("views/component");

module.exports = ComponentListView = (function(_super) {
  __extends(ComponentListView, _super);

  function ComponentListView() {
    _ref = ComponentListView.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  ComponentListView.prototype.tagName = "li";

  ComponentListView.prototype.initialize = function(opts) {
    this.showAll = true;
    ComponentListView.__super__.initialize.call(this, opts);
    this.template = require("templates/component.list");
    this.className = "" + this.type + " " + this.type + "-list " + this.type + "-list-item list-group-item";
    this.setName();
    return null;
  };

  return ComponentListView;

})(ComponentView);
});

;require.register("views/component", function(exports, require, module) {
var BaseView, ComponentView, _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

BaseView = require("views/base");

module.exports = ComponentView = (function(_super) {
  __extends(ComponentView, _super);

  function ComponentView() {
    _ref = ComponentView.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  ComponentView.prototype.initialize = function(opts) {
    if (opts.type != null) {
      this.type = opts.type;
    }
    if (this.showAll == null) {
      this.showAll = false;
    }
    this.templateFile = "templates/component.list";
    this.className = this.type;
    this.setName();
    return null;
  };

  ComponentView.prototype.render = function() {
    this.$el.html(this.template({
      row: this.model.toJSON(),
      cid: this.model.cid,
      cost: this.model.calculate != null ? this.model.calculate() : void 0,
      types: this.model.types != null ? this.model.types : null,
      fields: this.model.getFields(this.showAll)
    }));
    return this;
  };

  return ComponentView;

})(BaseView);
});

;require.register("views/job-element-form", function(exports, require, module) {
var ComponentView, JobElementFormView, _ref,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

ComponentView = require("views/component");

module.exports = JobElementFormView = (function(_super) {
  __extends(JobElementFormView, _super);

  function JobElementFormView() {
    this.refresh = __bind(this.refresh, this);
    this.render = __bind(this.render, this);
    _ref = JobElementFormView.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  JobElementFormView.prototype.tagName = "article";

  JobElementFormView.prototype.events = {
    "change .field": "refresh"
  };

  JobElementFormView.prototype.initialize = function(opts) {
    JobElementFormView.__super__.initialize.call(this, opts);
    this.templateFile = "templates/" + this.type + ".form";
    this.template = require(this.templateFile);
    this.id = "job-form-" + this.type;
    this.className = "" + this.type + " " + this.type + "-form col-xs-12 form-horizontal";
    if (opts.next != null) {
      this.next = opts.next;
    }
    if (opts.title != null) {
      this.title = opts.title;
    }
    this.setName();
    _.bindAll(this, "refresh");
    return null;
  };

  JobElementFormView.prototype.render = function() {
    var _this = this;
    console.log("Rendering " + this.type + " element");
    this.$el.empty();
    this.$el.html(this.template({
      row: this.model.toJSON(),
      cid: this.model.cid,
      type: this.type,
      next: this.next,
      title: this.title,
      cost: this.model.cost,
      types: this.model.types
    }));
    _(this._children).each(function(child) {
      return _this.$el.append(child.render().$el);
    });
    return this;
  };

  JobElementFormView.prototype.refresh = function(event) {
    var target;
    target = $(event.currentTarget);
    this.model.set(target.attr('name'), target.val());
    console.log("View changed", target.attr('name'), target.val());
    return null;
  };

  return JobElementFormView;

})(ComponentView);
});

;require.register("views/job-list", function(exports, require, module) {
var ComponentView, JobListView, _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

ComponentView = require("views/component");

module.exports = JobListView = (function(_super) {
  __extends(JobListView, _super);

  function JobListView() {
    _ref = JobListView.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  JobListView.prototype.initialize = function(opts) {
    JobListView.__super__.initialize.call(this, opts);
    this.template = require("templates/job.list");
    this.className = "" + this.type + " " + this.type + "-list " + this.type + "-list-item col-xs-12 list-group";
    this.setName();
    return null;
  };

  return JobListView;

})(ComponentView);
});

;require.register("views/job", function(exports, require, module) {
var BaseView, CollectionListView, JobView, _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

BaseView = require("views/base");

CollectionListView = require("views/collection-list");

module.exports = JobView = (function(_super) {
  __extends(JobView, _super);

  function JobView() {
    _ref = JobView.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  JobView.prototype.initialize = function(opts) {
    var collection, collections, data, _i, _len;
    this._children = [];
    this.id = this.model.cid;
    this.className = "" + this.type + "-overview";
    this.setName();
    this.template = require("templates/job");
    collections = ["concrete", "labor", "materials", "equipment"];
    for (_i = 0, _len = collections.length; _i < _len; _i++) {
      collection = collections[_i];
      data = this.model.attributes[collection] != null ? this.model.attributes[collection] : false;
      this._children.push(new CollectionListView({
        className: "job-list-collection panel panel-default",
        collection: data,
        title: collection,
        type: collection
      }));
    }
    return null;
  };

  JobView.prototype.render = function() {
    var _this = this;
    console.log("Rendering job overview");
    this.model.calculate();
    this.$el.html(this.template({
      row: this.model.getFields(),
      cost: this.model.cost
    }));
    _(this._children).each(function(child) {
      return _this.$(".job.items").append(child.render().$el);
    });
    return this;
  };

  return JobView;

})(BaseView);
});

;require.register("views/page", function(exports, require, module) {
var PageView, _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

module.exports = PageView = (function(_super) {
  __extends(PageView, _super);

  function PageView() {
    _ref = PageView.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  PageView.prototype.tagName = "section";

  PageView.prototype.className = "page container";

  PageView.prototype.title = "Cole";

  PageView.prototype.text = null;

  PageView.prototype.subView = null;

  PageView.prototype.initialize = function(opts) {
    this.section = require("templates/page");
    this.header = require("templates/header");
    if (opts.title != null) {
      this.title = opts.title;
    }
    if (opts.text != null) {
      this.text = opts.text;
    }
    if (opts.subView != null) {
      this.subView = opts.subView;
    }
    return true;
  };

  PageView.prototype.render = function() {
    var header;
    this.$el.empty();
    if (this.title != null) {
      header = this.header({
        title: this.title
      });
      console.log("Rendering page header");
      this.$el.append(header);
    }
    if (this.text != null) {
      this.$el.append(this.section({
        text: this.text
      }));
      console.log("Rendering page view");
    }
    if (this.subView != null) {
      console.log("Appending form view");
      this.$el.append(this.subView.render().$el);
    }
    return this;
  };

  return PageView;

})(Backbone.View);
});

;
//# sourceMappingURL=app.js.map