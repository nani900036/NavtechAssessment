using NavtechAssesment.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading;
using System.Web.Http;

namespace NavtechAssesment.Controllers
{
    public class OrdersController : ApiController
    {
        string Type = "";
        Guid Value;

        public IEnumerable<Order> Get()
        {
            string UserName = Thread.CurrentPrincipal.Identity.Name;
            using (OrdersEntities3 order = new OrdersEntities3())
            {
                Type = order.UsersTables.FirstOrDefault(x => x.NAME == UserName).Type;
                if (Type == "User")
                {
                    Value = order.UsersTables.FirstOrDefault(x => x.NAME == UserName).UserId;
                    return order.Orders.Where(x => x.UserID == Value).ToList();
                }
                else
                {
                    return order.Orders.ToList();
                }
            }

        }
        public HttpResponseMessage Get(int id)
        {
            using (OrdersEntities3 order = new OrdersEntities3())

            {
                string UserName = Thread.CurrentPrincipal.Identity.Name;
                Type = order.UsersTables.FirstOrDefault(x => x.NAME == UserName).Type;
                Value = order.UsersTables.FirstOrDefault(x => x.NAME == UserName).UserId;
                if (Type == "User")
                {
                    if (order.Orders.Any(x => x.OrderID == id && x.UserID == Value))
                    {
                        var orders = order.Orders.FirstOrDefault(ord => ord.OrderID == id);
                        if (orders != null)
                            return Request.CreateResponse(HttpStatusCode.OK, orders);
                        else
                            return Request.CreateErrorResponse(HttpStatusCode.NotFound, "");
                    }
                    else
                        return Request.CreateErrorResponse(HttpStatusCode.Unauthorized, "you dont have permission to access order " + id);
                }
                else
                {
                    var orders = order.Orders.FirstOrDefault(ord => ord.OrderID == id);
                    if (orders != null)
                        return Request.CreateResponse(HttpStatusCode.OK, orders);
                    else
                        return Request.CreateErrorResponse(HttpStatusCode.NotFound, "");
                }

            }
        }
            public HttpResponseMessage post([FromBody] Order order)
            {
            try
            {
                using (OrdersEntities3 orders = new OrdersEntities3())
                {
                    if (orders.Orders.Any(x => x.OrderID == order.OrderID))
                    {
                        return Request.CreateErrorResponse(HttpStatusCode.BadRequest, "The  " + order.OrderID + " already exists");
                    }
                    else
                    {
                        orders.Orders.Add(order);
                        orders.SaveChanges();
                        orders.SEndMail(order.UserID);
                        var message = Request.CreateResponse(HttpStatusCode.Created, order);
                        message.Headers.Location = new Uri(Request.RequestUri + order.OrderName);
                        return message;
                    }

                }
            }
            catch (Exception ex)
            {
                return Request.CreateErrorResponse(HttpStatusCode.BadRequest, ex);
            }
            }
        [HttpPut]

        public HttpResponseMessage PUT(int id, [FromBody]Order order)
        {
            using (OrdersEntities3 ord = new OrdersEntities3())
            {
                string UserName = Thread.CurrentPrincipal.Identity.Name;
                Type = ord.UsersTables.FirstOrDefault(x => x.NAME == UserName).Type;
                Value = ord.UsersTables.FirstOrDefault(x => x.NAME == UserName).UserId;
                if (Type == "User")
                {
                    if (ord.Orders.Any(x => x.OrderID == id && x.UserID == Value))
                    {
                        var obj = ord.Orders.FirstOrDefault(x => x.OrderID == id);
                        obj.ShippingAddress = order.ShippingAddress;
                        obj.OrderName = order.OrderName;
                        obj.OrderDetails = order.OrderDetails;
                        ord.SaveChanges();
                        return Request.CreateResponse(HttpStatusCode.OK);
                    }
                    else
                    {
                        return Request.CreateErrorResponse(HttpStatusCode.Unauthorized, "Dont have permistion to modify OrderID " + id);
                    }

                }
                else
                {
                    var obj = ord.Orders.FirstOrDefault(x => x.OrderID == id);
                    obj.ShippingAddress = order.ShippingAddress;
                    obj.OrderName = order.OrderName;
                    obj.OrderDetails = order.OrderDetails;
                    obj.OrderStatus = order.OrderStatus;

                    ord.SaveChanges();
                    return Request.CreateResponse(HttpStatusCode.OK);
                }
            }
        }
        [HttpDelete]

        public HttpResponseMessage Delete([FromUri] int id)
        {

            using (OrdersEntities3 orders = new OrdersEntities3())
            {
                string UserName = Thread.CurrentPrincipal.Identity.Name;
                Value = orders.UsersTables.FirstOrDefault(x => x.NAME == UserName).UserId;
                Type = orders.UsersTables.FirstOrDefault(x => x.NAME == UserName).Type;
                var ord = orders.Orders.FirstOrDefault(x => x.OrderID == id);
                if (ord == null)
                {
                    return Request.CreateErrorResponse(HttpStatusCode.NotFound, "OrderID " + id);
                }
                else
                {
                    if (Type == "User")
                    {
                        if (orders.Orders.Any(x => x.OrderID == id && x.UserID == Value))
                        {
                            orders.Orders.Remove(ord);
                            orders.SaveChanges();
                            return Request.CreateResponse(HttpStatusCode.OK);
                        }
                        else
                        {
                            return Request.CreateErrorResponse(HttpStatusCode.Unauthorized, "Dont have permistion delete OrderID " + id);
                        }

                    }
                    else
                    {
                        orders.Orders.Remove(ord);
                        orders.SaveChanges();
                        return Request.CreateResponse(HttpStatusCode.OK);
                    }
                }

            }
        }

    }
}

