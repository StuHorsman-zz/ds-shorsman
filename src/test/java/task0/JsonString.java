package ccp.shorsman.task0;

import org.json.simple.JSONObject;
import org.joda.time.DateTime;
import org.json.simple.JSONValue;
import org.	apache.commons.lang.time.DateUtils; 

import com.sun.org.apache.xerces.internal.impl.xpath.regex.ParseException;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.TimeZone;

public class JsonString {

    public static void main(String args[]) throws Exception
    {
        if (args.length < 1) return;

        String line = args[0];

        line = line.trim();
        line = line.replace("\"itemId\"\"", "\"itemId\"");
        line = line.replace("\"created_at\"", "\"createdAt\"");
        line = line.replace("\"session_id\"", "\"sessionId\"");
        line = line.replace("\"popular\"", "\"popularItems\"");
        line = line.replace("\"popularItem\"", "\"popularItems\"");
        line = line.replace("\"recommended\"", "\"recommendedItems\"");
        line = line.replace("\"recommendedItem\"", "\"recommendedItems\"");
        line = line.replace("\"recs\"", "\"recommendedItems\"");
        line = line.replace("\"recent\"", "\"recentItem\"");
        line = line.replace("\"item_id\"", "\"itemId\"");

        //JSONObject json_data = (JSONObject) JSONValue.parse(line);
        //String createdAt = (String) json_data.get("createdAt");
        String createdAt = "2013-06-02T20:00:00-00:00";
        
        SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
        SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
        SimpleDateFormat newCreatedAt = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        
        Date dt1 = sdf1.parse(createdAt);
        sdf1.setTimeZone(TimeZone.getTimeZone("UTC"));
        
        //newCreatedAt = sdf1.format(dt);

        //line = line.replace(createdAt, newCreatedAt);

        //System.out.println(createdAt + "," + newCreatedAt);
        System.out.println(createdAt + "," + newCreatedAt);

    }
}
