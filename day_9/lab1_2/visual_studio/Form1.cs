using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace RGBPaint
{
    public partial class Form1 : Form
    {
        Bitmap pic, pic2;
        Size size;
        Graphics g;
        int x1, y1;
        int blackargb, redargb, greenargb, blueargb, whiteargb;
        public Form1()
        {
            InitializeComponent();
            pic = new Bitmap(pictureBox1.Width, pictureBox1.Height);
            blackargb = Color.Black.ToArgb();
            redargb = Color.Red.ToArgb();
            greenargb = Color.Green.ToArgb();
            blueargb = Color.Blue.ToArgb();
            whiteargb = Color.White.ToArgb();
            size = new Size(80, 60);
            x1 = y1 = 0;
        }


        private void button1_Click(object sender, EventArgs e)
        {
            Button b = (Button)sender;
            button5.BackColor = b.BackColor;
        }

        private void saveToolStripMenuItem_Click(object sender, EventArgs e)
        {
            saveFileDialog1.ShowDialog();
            pic2 = new Bitmap(pictureBox1.Image, size);
            if (saveFileDialog1.FileName != "") pic2.Save(saveFileDialog1.FileName);
        }

        private void openToolStripMenuItem_Click(object sender, EventArgs e)
        {
            openFileDialog1.ShowDialog();
            if(openFileDialog1.FileName != "")
            {
                pic = (Bitmap)Image.FromFile(openFileDialog1.FileName);
                pictureBox1.Image = pic;
            }
        }

        private void saveRGBToolStripMenuItem_Click(object sender, EventArgs e)
        {
            saveFileDialog1.ShowDialog();
            pic2 = new Bitmap(pictureBox1.Image, size);
            for (int i = 0; i < pic2.Height; i++)
            {
                for (int j = 0; j < pic2.Width; j++)
                {
                    int pixelcolor = pic2.GetPixel(j, i).ToArgb();
                    //Boolean isblack = pixelcolor == Color.Black;
                    //Boolean isred = pixelcolor == Color.Red;
                    //Boolean isgreen = pixelcolor == Color.Green;
                    //Boolean isblue = pixelcolor == Color.Blue;
                    Boolean isblack = pixelcolor == blackargb;
                    Boolean isred = pixelcolor == redargb;
                    Boolean isgreen = pixelcolor == greenargb;
                    Boolean isblue = pixelcolor == blueargb;
                    if ((isblack || isred || isgreen || isblue) == false)
                    pic2.SetPixel(j, i, Color.White);
                }
            }
            if (saveFileDialog1.FileName != "") pic2.Save(saveFileDialog1.FileName);
        }

        private void saveTXTsToolStripMenuItem_Click(object sender, EventArgs e)
        {
            string xpath, ypath, rgbpath;
            saveTXTFileDialog2.ShowDialog();
            rgbpath = saveTXTFileDialog2.FileName;
            //xpath = @"";
            //ypath = @"";
            System.IO.StreamWriter rgbwriter;//, xwriter, ywriter ;
            rgbwriter = new System.IO.StreamWriter(rgbpath, false);
            //xwriter = new System.IO.StreamWriter(xpath, false);
            //ywriter = new System.IO.StreamWriter(ypath, false);
            //int counter = 0;
            for (int i = 0; i < pic2.Height; i++)
            {
                for (int j = 0; j < pic2.Width; j++)
                {
                    //xwriter.WriteLine(j.ToString("x"));
                    //ywriter.WriteLine(i.ToString("x"));
                    int pixel = pic2.GetPixel(j, i).ToArgb();
                    if (pixel == blackargb)
                    {
                        rgbwriter.WriteLine("0");
                    }
                    else if (pixel == redargb)
                    {
                        rgbwriter.WriteLine("4");
                    }
                    else if (pixel == greenargb)
                    {
                        rgbwriter.WriteLine("2");
                    }
                    else if (pixel == blueargb)
                    {
                        rgbwriter.WriteLine("1");
                    }
                    else if (pixel == whiteargb)
                    {
                        rgbwriter.WriteLine("7");
                    }
                }
            }
            rgbwriter.Close();
            //xwriter.Close();
            //ywriter.Close();
        }

        private void pictureBox1_MouseMove(object sender, MouseEventArgs e)
        {
            Pen p = new Pen(button5.BackColor, trackBar1.Value);
            p.StartCap = System.Drawing.Drawing2D.LineCap.Round;
            p.EndCap = System.Drawing.Drawing2D.LineCap.Round;
            g = Graphics.FromImage(pic);
            if (e.Button == MouseButtons.Left)
            {
                g.DrawLine(p, x1, y1, e.X, e.Y);
                pictureBox1.Image = pic;
            }
            x1 = e.X;
            y1 = e.Y;
        }
    }
}
