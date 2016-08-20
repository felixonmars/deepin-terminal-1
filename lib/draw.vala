/* -*- Mode: Vala; indent-tabs-mode: nil; tab-width: 4 -*-
 * -*- coding: utf-8 -*-
 *
 * Copyright (C) 2011 ~ 2016 Deepin, Inc.
 *               2011 ~ 2016 Wang Yong
 *
 * Author:     Wang Yong <wangyong@deepin.com>
 * Maintainer: Wang Yong <wangyong@deepin.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */ 

using Cairo;

namespace Draw {
    public void draw_surface(Cairo.Context cr, ImageSurface surface, int x = 0, int y = 0, double alpha = 1.0) {
        if (surface != null) {
            cr.set_source_surface(surface, x, y);
            cr.paint_with_alpha(alpha);
        }
    }

    public void draw_text(Cairo.Context cr, string text, int x, int y, int width, int height, int size,
                            Pango.Alignment horizontal_alignment=Pango.Alignment.LEFT,
                            string vertical_align = "middle",
                            int? wrap_width=null) {
        cr.save();
        
        var font_description = new Pango.FontDescription();
        font_description.set_size((int)(size * Pango.SCALE));
        
        var layout = Pango.cairo_create_layout(cr);
        layout.set_font_description(font_description);
        layout.set_markup(text, text.length);
        layout.set_alignment(horizontal_alignment);
        if (wrap_width == null) {
            layout.set_single_paragraph_mode(true);
            layout.set_width(width * Pango.SCALE);
            layout.set_ellipsize(Pango.EllipsizeMode.END);
        } else {
            layout.set_width(wrap_width * Pango.SCALE);
            layout.set_wrap(Pango.WrapMode.WORD);
        }

        int text_width, text_height;
        layout.get_pixel_size(out text_width, out text_height);

        int render_y;
        if (vertical_align == "top") {
            render_y = y;
        } else if (vertical_align == "middle") {
            render_y = y + int.max(0, (height - text_height) / 2);
        } else {
            render_y = y + int.max(0, height - text_height);
        }
        
        cr.move_to(x, render_y);
        Pango.cairo_update_layout(cr, layout);
        Pango.cairo_show_layout(cr, layout);
        
        cr.restore();
    }

    public void draw_layout(Cairo.Context cr, Pango.Layout layout, int x, int y) {
        cr.move_to(x, y);
        Pango.cairo_update_layout(cr, layout);
        Pango.cairo_show_layout(cr, layout);
    }

    public void draw_rectangle(Cairo.Context cr, int x, int y, int w, int h, bool fill=true) {
        cr.rectangle(x, y, w, h);
        if (fill) {
            cr.fill();
        } else {
            cr.stroke();
        }
    }

	public void draw_rounded_rectangle(Context cr, int x, int y, int width, int height, double r, bool fill=true) {
        // Top side.
        cr.move_to(x + r, y);
        cr.line_to(x + width - r, y);
	    
        // Top-right corner.
        cr.arc(x + width - r, y + r, r, Math.PI * 3 / 2, Math.PI * 2);
	    
        // Right side.
        cr.line_to(x + width, y + height - r);
	    
        // Bottom-right corner.
        cr.arc(x + width - r, y + height - r, r, 0, Math.PI / 2);
	    
        // Bottom side.
        cr.line_to(x + r, y + height);
	    
        // Bottom-left corner.
        cr.arc(x + r, y + height - r, r, Math.PI / 2, Math.PI);
	    
        // Left side.
        cr.line_to(x, y + r);
	    
        // Top-left corner.
        cr.arc(x + r, y + r, r, Math.PI, Math.PI * 3 / 2);
	    
        // Close path.
        cr.close_path();
		
		if (fill) {
			cr.fill();
		} else {
			cr.stroke();
		}
	}

	public void draw_search_rectangle(Context cr, int x, int y, int width, int height, double r, bool fill=true) {
        // Top side.
        cr.move_to(x, y);
        cr.line_to(x + width, y);
	    
        // Right side.
        cr.line_to(x + width, y + height);
	    
        // Bottom side.
        cr.line_to(x + r, y + height);
	    
        // Bottom-left corner.
        cr.arc(x + r, y + height - r, r, Math.PI / 2, Math.PI);
	    
        // Left side.
        cr.line_to(x, y);
	    
        // Close path.
        cr.close_path();
		
		if (fill) {
			cr.fill();
		} else {
			cr.stroke();
		}
	}

	public void draw_radial(Cairo.Context cr, int x, int width, int height, Gdk.RGBA center_color, Gdk.RGBA edge_color) {
        Cairo.Pattern pattern = new Cairo.Pattern.radial(x + width / 2, height, width / 2, x + width / 2, height, 0);
        pattern.add_color_stop_rgba(1, center_color.red, center_color.green, center_color.blue, center_color.alpha);
        pattern.add_color_stop_rgba(0, edge_color.red, edge_color.green, edge_color.blue, edge_color.alpha);        
        cr.set_source(pattern);
        cr.paint();
    }

    public void clip_rectangle(Cairo.Context cr, int x, int y, int w, int h) {
         cr.rectangle(x, y, w, h);
         cr.clip();
    }
}