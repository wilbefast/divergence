return {
  version = "1.1",
  luaversion = "5.1",
  orientation = "orthogonal",
  width = 8,
  height = 8,
  tilewidth = 32,
  tileheight = 32,
  properties = {
    ["clones"] = "false"
  },
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
          width = 32,
          height = 256,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 224,
          y = 0,
          width = 32,
          height = 256,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 32,
          y = 0,
          width = 192,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 32,
          y = 224,
          width = 192,
          height = 32,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 32,
          y = 64,
          width = 96,
          height = 160,
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
          x = 160,
          y = 64,
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
          x = 32,
          y = 32,
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
          x = 160,
          y = 128,
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
          x = 192,
          y = 192,
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
      name = "doors",
      visible = true,
      opacity = 1,
      properties = {},
      objects = {
        {
          name = "",
          type = "",
          shape = "rectangle",
          x = 96,
          y = 32,
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
      objects = {}
    }
  }
}
