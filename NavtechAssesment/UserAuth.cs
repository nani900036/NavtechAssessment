using NavtechAssesment.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace NavtechAssesment
{
    public class UserAuth
    {
        public static bool Login(string UserName, String Password)
        {
            using (OrdersEntities3 orders = new OrdersEntities3())
            {
               return orders.UsersTables.Any(usr => usr.NAME.Equals(UserName, StringComparison.OrdinalIgnoreCase) && usr.Password==Password);
            }
           
        }
    }
}