return {
  version = "1.1",
  luaversion = "5.1",
  orientation = "orthogonal",
  width = 16,
  height = 16,
  tilewidth = 32,
  tileheight = 32,
  properties = {},
  tilesets = {},
  layers = {
    {
      type = "objectgroup",
      name = "walls",
      visible = true,
      opacity = 1,
      properties = {},
      objects = {
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 0,
          y = 0,
          width = 96,
          height = 512,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 96,
          y = 0,
          width = 416,
          height = 96,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 416,
          y = 96,
          width = 96,
          height = 416,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 96,
          y = 416,
          width = 320,
          height = 96,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 256,
          y = 128,
          width = 32,
          height = 256,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 320,
          y = 352,
          width = 64,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 288,
          y = 288,
          width = 96,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 320,
          y = 224,
          width = 96,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 320,
          y = 96,
          width = 96,
          height = 96,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 128,
          y = 128,
          width = 128,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 128,
          y = 192,
          width = 32,
          height = 192,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 192,
          y = 288,
          width = 32,
          height = 64,
          visible = true,
          properties = {}
        }
      }
    },
    {
      type = "objectgroup",
      name = "player",
      visible = true,
      opacity = 1,
      properties = {},
      objects = {
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 192,
          y = 224,
          width = 32,
          height = 32,
          visible = true,
          properties = {}
        }
      }
    },
    {
      type = "objectgroup",
      name = "exit",
      visible = true,
      opacity = 1,
      properties = {},
      objects = {
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 384,
          y = 192,
          width = 32,
          height = 32,
          visible = true,
          properties = {}
        }
      }
    },
    {
      type = "objectgroup",
      name = "boxes",
      visible = true,
      opacity = 1,
      properties = {},
      objects = {
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 224,
          y = 256,
          width = 32,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 192,
          y = 256,
          width = 32,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 128,
          y = 160,
          width = 32,
          height = 32,
          visible = true,
          properties = {}
        }
      }
    },
    {
      type = "objectgroup",
      name = "plates",
      visible = true,
      opacity = 1,
      properties = {},
      objects = {
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 96,
          y = 384,
          width = 32,
          height = 32,
          visible = true,
          properties = {
            ["circuit"] = "1"
          }
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 96,
          y = 352,
          width = 32,
          height = 32,
          visible = true,
          properties = {
            ["circuit"] = "2"
          }
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 128,
          y = 384,
          width = 32,
          height = 32,
          visible = true,
          properties = {
            ["circuit"] = "2"
          }
        }
      }
    },
    {
      type = "objectgroup",
      name = "doors",
      visible = true,
      opacity = 1,
      properties = {},
      objects = {
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 320,
          y = 192,
          width = 32,
          height = 32,
          visible = true,
          properties = {
            ["circuit"] = "2"
          }
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 384,
          y = 288,
          width = 32,
          height = 32,
          visible = true,
          properties = {
            ["circuit"] = "1"
          }
        }
      }
    },
    {
      type = "objectgroup",
      name = "keys",
      visible = true,
      opacity = 1,
      properties = {},
      objects = {
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 224,
          y = 160,
          width = 32,
          height = 32,
          visible = true,
          properties = {
            ["circuit"] = "1"
          }
        }
      }
    }
  }
}
